# this is the main class that parses the data before putting it in the DB
class DataParser
  def self.update_data
    last_update = self.get_lastest_update
    twitter_frequency = 30.seconds
    github_frequency = 2.minutes
    blog_frequency = 2.minutes
    
    # Check when the last update has been fired, if it's > X seconds, it can fire again
    # This is to to prevent getting banned from the service APIs

    # twitter
    if last_update.tweet_update < (DateTime.now.new_offset(0) - twitter_frequency)
      # grab all of the members
      members = Member.all

      # make sure we have members to match against
      if !members.empty?
        # update tweets table
        self.update_tweets(members)
      end

      last_update.update_attributes({:tweet_update => DateTime.now.new_offset(0)})
    end

    # github
    if last_update.git_update < (DateTime.now.new_offset(0) - github_frequency)
      # update git_events table
      self.update_git_events
      last_update.update_attributes({:git_update => DateTime.now.new_offset(0)})
    end

    # blogs
    if last_update.blog_update < (DateTime.now.new_offset(0) - blog_frequency)
      # update blog_posts table
      self.update_blog_posts
      last_update.update_attributes({:blog_update => DateTime.now.new_offset(0)})
    end
    
  end

  def self.update_tweets(members)
    begin
      # get list of new tweets
      twitter_list = self.get_tweets

      # loop through each new tweet
      twitter_list.each do |new_tweet|
        # compare the tweet user name vs the new tweet username
        members.each do |member|
          tweet_found = false

          # check if usernames are equal (case insensitive)
          if member.twitter.casecmp(new_tweet.user.screen_name) == 0
            # create tweet
            member.tweets.create!({
              :date     => Time.parse(new_tweet.created_at.to_s).utc,
              :content  => new_tweet.text,
              :url      => "https://twitter.com/#{new_tweet.user.screen_name}/status/#{new_tweet.id}",
              :since_id => new_tweet.id})
              
            tweet_found = true
          end
          
          # if a match is found for the tweet break out of this loop
          break if tweet_found == true
        end
      end
    rescue => ex
      puts 'twitter failed!!'
      puts ex.inspect
    end 
  end

  def self.update_git_events
    begin
      # get list of GitHubbists
      githubbists = Member.where("github is not null")

      # update their feeds
      githubbists.each do |member|
        # get member's recent events (of types we care about)
        events = self.get_git_events(member, ["PushEvent"])

        # write event to DB
        events.each do |event|
          message = self.parse_event_message(CGI.unescapeHTML(event.content.to_s.force_encoding 'utf-8'))

          member.git_events.create!( :date => event.updated,
                                     :event => message)
        end
      end      
    rescue => ex
      puts 'git_events failed!!'
      puts ex.inspect
    end
  end
  
  def self.update_blog_posts
    begin
      # get list of members who have blogs
      bloggers = Member.where("blogrss is not null")
      
      # loop through members
      bloggers.each do |blogger|
        # get member's recent posts
        posts = self.get_blog_posts(blogger)
        
        # write feed posts to db
        posts.each do |post|
          blogger.blog_posts.create!( :title   => post.title,
                                      :summary => post.summary,
                                      :date    => post.updated.utc,
                                      :url     => post.link )
        end
      end
    rescue => ex
      puts 'blog_posts failed!!'
      puts ex.inspect
    end
  end
  
  
private
  def self.get_lastest_update
    # try and get the last update
    last_update = LastUpdate.first
    
    # Make sure the last update exists
    if last_update.nil?
      # set the last update to today - 30 days (to get all the most recent items)
      update_time = DateTime.now.new_offset(0) - 30.days
      last_update = LastUpdate.create!({ :tweet_update => update_time,
                                         :git_update => update_time,
                                         :blog_update => update_time })
    end
    
    last_update
  end

  def self.get_tweets
    # create twitter client
    twitter = Twitter::Client.new

    # grab the most recent tweet
    last_updated_tweet = Tweet.order("since_id desc").first
    
    # If there are no since_id's in the db, we go and get all of the possible tweets
    if last_updated_tweet.nil?
      twitter_list = twitter.list_timeline('yegrb-members')
    else
      # grab the newest tweets from the yeg-members list based on the since_id
      twitter_list = twitter.list_timeline('yegrb-members', {:since_id => last_updated_tweet.since_id, :include_rts => true})
    end
    
    return twitter_list
  end

  def self.parse_event_message(html)
    # this is a block of html tags... grunt it out
    str = "to master at"
    x = html.index(str) + str.length
    s = html.index("<a", x)
    str = "</a>"
    e = html.index(str, s) + str.length
    repo_url = html[s..e]
    repo_url.sub!("href=\"", "target=\"_blank\" href=\"https://github.com")
    
    message = "Push to #{repo_url}!"

    # want ALL commit messages
    str = "committed"
    x = html.index(str)

    while !x.nil? do
      x += str.length
      s = html.index("<a", x)
      str = ">"
      e = html.index(str, s) + str.length - 1
      commit_url = "&#8220;#{html[s..e]}"
      commit_url.sub!("href=\"", "target=\"_blank\" href=\"https://github.com")
      
      str = "<blockquote>"
      s = html.index(str, e) + str.length
      str = "</blockquote>"
      e = html.index(str, s) - 1
      commit_message = html[s..e]

      commit_url += "#{commit_message}</a>&#8221;"

      message += "<br/>#{commit_url}"
      
      str = "committed"
      x = html.index(str, e)
    end

    return message    
  end

  def self.get_git_events(member, report_on)
    # get member's feed
    feed_url = "https://github.com/#{member.github}.atom" 
    rest_client = RestClient::Resource.new feed_url
    feed = SimpleRSS.parse(rest_client.get)

    # get member's last event in the DB
    last_event = member.git_events.order("date DESC").first

    if last_event.nil?
      # no existing events, get all
      events = feed.items
    else
      # only include most recent events
      events = feed.items.find_all{ |item| item.updated > last_event.date }
    end

    # only include commits
    events.delete_if{ |event| !event.id.include?("PushEvent") }

    return events
  end

  def self.get_blog_posts(member)
    # get member's blog feed
    feed_url = member.blogrss
    rest = RestClient::Resource.new feed_url
    feed = SimpleRSS.parse(rest.get)

    # get most recent blog_post in db by this member
    last_post = member.blog_posts.order("date desc").first

    if last_post.nil?
      # get all posts
      posts = feed.items
    else
      # filter feed for posts more recent than latest in db
      posts = feed.items.find_all{ |item| item.updated > last_post.date }
    end

    return posts
  end

end


