# this is the main class that parses the data before putting it in the DB
class DataParser
  
  def self.update_data
    twitter_frequency = 30.seconds
    github_frequency = 2.minutes
    blog_frequency = 2.minutes
    
    # Check when the last update has been fired, if it's > X seconds, it can fire again
    # This is to to prevent getting banned from the service APIs

    # grab all of the approved members
    members = Member.where(:status => 'approved')

    # make sure we have members to match against
    if !members.empty?
      last_update = self.get_lastest_update

      # twitter
      if last_update.tweet_update < (DateTime.now.new_offset(0) - twitter_frequency)
        self.update_tweets(members.where("twitter is not null"))
        last_update.update_attributes({:tweet_update => DateTime.now.new_offset(0)})
      end

      # github
      if last_update.git_update < (DateTime.now.new_offset(0) - github_frequency)
        self.update_git_events(members.where("github is not null"))
        last_update.update_attributes({:git_update => DateTime.now.new_offset(0)})
      end

      # blogs
      if last_update.blog_update < (DateTime.now.new_offset(0) - blog_frequency)
        self.update_blog_posts(members.where("blogrss is not null"))
        last_update.update_attributes({:blog_update => DateTime.now.new_offset(0)})
      end

    end
  end

  def self.update_tweets(tweeters)
    begin
      # get list of new tweets from Twitter API
      twitter_list = self.get_tweets

      # loop through each new tweet
      twitter_list.each do |new_tweet|
        # compare the tweet user name vs the new tweet username
        tweeters.each do |tweeter|
          tweet_found = false

          # check if usernames are equal (case insensitive)
          if tweeter.twitter.casecmp(new_tweet.user.screen_name) == 0
            # create tweet
            tweeter.tweets.create!({
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
      puts '~~~~ twitter failed!!'
      puts ex.inspect
    end 
  end

  def self.update_git_events(githubbists)
    begin
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
      puts '~~~~ git_events failed!!'
      puts ex.inspect
    end
  end
  
  def self.update_blog_posts(bloggers)
    begin
      # define max summary length to display
      max_length = 100
      
      # loop through members
      bloggers.each do |blogger|
        # get member's recent posts
        posts = self.get_blog_posts(blogger)
        
        # write feed posts to db
        posts.each do |post|
          summary = CGI.unescapeHTML(post.summary.to_s.force_encoding 'utf-8')
          summary = self.ellipsis_if_longer_than(summary, max_length)

          blogger.blog_posts.create!( :title   => post.title,
                                      :summary => summary,
                                      :date    => post.updated.utc,
                                      :url     => post.link )
        end
      end
    rescue => ex
      puts '~~~~ blog_posts failed!!'
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
    target_string = "to master at"
    target_index = html.index(target_string) + target_string.length
    start_index = html.index("<a", target_index)
    target_string = "</a>"
    end_index = html.index(target_string, start_index) + target_string.length
    repo_url = html[start_index..end_index]
    repo_url.sub!("href=\"", "target=\"_blank\" href=\"https://github.com")
    
    message = "<p class='itemTitle'>Push to #{repo_url}</p>"

    # want ALL commit messages
    target_string = "committed"
    target_index = html.index(target_string)

    while !target_index.nil? do
      # find the commit url
      start_index = html.index("<a", target_index)
      end_index = html.index(">", start_index)

      commit_url = "<p class='itemDetail commitListItem'>#{html[start_index..end_index]}"
      commit_url.sub!("href=\"", "target=\"_blank\" href=\"https://github.com")
      
      message += "#{commit_url}"

      # find the commit message
      start_index = html.index("<blockquote>", end_index) + "<blockquote>".length
      end_index = html.index("</blockquote>", start_index) - 1

      commit_message = html[start_index..end_index]

      message += "#{commit_message}</a></p>"
      
      # see if there's more
      target_string = "committed"
      target_index = html.index(target_string, end_index)
    end


    return message    
  end

  def self.get_git_events(member, report_on)
    # get member's feed
    feed_url = "https://github.com/#{member.github}.atom" 
    rest_client = RestClient::Resource.new feed_url
    feed = SimpleRSS.parse(rest_client.get.to_s.force_encoding 'utf-8')

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
    feed = SimpleRSS.parse(rest.get.to_s.force_encoding 'utf-8')

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

  def self.ellipsis_if_longer_than(string, length)
    if string.length > length
      "#{string[0..length-4]}..."
    else
      string
    end
  end

end


