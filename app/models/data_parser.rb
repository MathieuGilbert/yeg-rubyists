# this is the main class that parses the data before putting it in the DB
class DataParser
  def self.update_data
    last_update = self.get_lastest_update
    
    # Check when the last update has been fired, if it's > X seconds, it can fire again
    # This is to to prevent getting banned from the service APIs
    if last_update.time < (DateTime.now.new_offset(0) - 30.seconds)
      # grab all of the members
      members = Member.all

      # make sure we have members to match against
      if !members.empty?
        # update tweets table
        self.update_tweets(members)
        
        # update git_events table
        self.update_git_events(members)
        
        # update blog_posts table
        self.update_blog_posts
      end

      last_update.update_attributes({:time => DateTime.now.new_offset(0)})
    end
  end

  def self.update_tweets(members)
    begin
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

      # loop through each new tweet
      twitter_list.each do |new_tweet|

        # compare the tweet user name vs the new tweet username
        members.each do |member|
          tweet_found = false

          # check if usernames are equal (case insensitive)
          if member.twitter.casecmp(new_tweet.user.screen_name) == 0
            
            # https://twitter.com/fnichol/status/170273083112947713
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
    rescue
      puts 'twitter failed!!'
    end 
  end

  def self.update_git_events(members)
    begin
      # get list of GitHubbists
      githubbists = Member.where("github is not null")

      # update their feeds
      githubbists.each do |member|
        # get member's recent events (of types we care about)
        events = self.get_git_events(member, ["PushEvent"])

        # write event to DB
        events.each do |event|
          message = CGI.unescapeHTML(event.content.to_s)
          url = "www.lol-not-needed.xxx"

          member.git_events.create!( :date => event.updated,
                                     :event => message,
                                     :url => url )
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
      last_update = LastUpdate.create!({:time => DateTime.now.new_offset(0) - 30.days})
    end
    
    last_update
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
      events = feed.items.find_all{ |item| item.updated > last_event.date &&
                                           item.id.include?("PushEvent") }
    end

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


  def self.event_message(event)
    # listing: http://developer.github.com/v3/events/types/
    case event.type
    when "CommitComment"
      "commented on #{event.payload.comment.url}: #{event.payload.comment.body}"
    when "CreateEvent"
      ""
    when "DeleteEvent"
      ""
    when "DownloadEvent"
      ""
    when "FollowEvent"
      ""
    when "ForkEvent"
      ""
    when "ForkApplyEvent"
     ""
    when "GistEvent"
      ""
    when "GollumEvent"
      ""
    when "IssueCommentEvent"
      ""
    when "IssuesEvent"
      ""
    when "MemberEvent"
      ""
    when "PublicEvent"
      ""
    when "PullRequestEvent"
      ""
    when "PushEvent"
      ""
    when "TeamAddEvent"
      ""
    when "WatchEvent"
      ""
    end
  end

end


