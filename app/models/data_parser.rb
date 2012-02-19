# this is the main class that parses the data before putting it in the DB
class DataParser
  def self.update_data
    last_update = self.get_lastest_update
    
    # Check when the last update has been fired, if it's > 2 minutes, it can fire again
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
      # get all events of type we care about
      events = self.get_git_events(["PushEvent"])

      # go through each event
      events.each do |event|
        # find the matching member
        members.each do |member|
          match_found = false

          if member.github.casecmp(event.actor.login) == 0
            # build an appropriate message based on the type of event

            if event.payload.commits.nil?
              message = "#{event} slipped through"
              url = "#"
            else
              message = event.payload.commits[0].message
              url = self.get_repo_url(event.payload.commits[0].url)
            end

            # save event to DB
            member.git_events.create!( :date  => event.created_at,
                                       :event => message,
                                       :url   => url)
            match_found = true
          end

          break if match_found
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
        # get most recent blog_post in db by this member
        last_post = blogger.blog_posts.order("date desc").first
        
        # get member's blog feed
        feed_url = blogger.blogrss
        rest = RestClient::Resource.new feed_url
        feed = SimpleRSS.parse(rest.get)
          
        if last_post.nil?
          # get all posts
          posts = feed.items
        else
          # filter feed for posts more recent than latest in db
          posts = feed.items.find_all{ |item| item.updated > last_post.date }
        end
        
        # write feed posts to db
        posts.each do |post|
          blogger.blog_posts.create!( :title   => post.title,
                                      :summary => post.summary,
                                      :date    => post.updated.utc,
                                      :url     => post.link )
        end
      end
    rescue
      puts 'blog_posts failed!!'
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

  def self.get_repo_url(commit_url)
    commit_url.gsub(/^.*\/repos/i, "https://github.com").gsub(/\/commits\/.*/i, "")
  end

  def self.get_git_events(report_on)
    # create GitHub client
    github = Github::new

    # get the most recent event in DB
    last_event = GitEvent.order("date DESC").first

    # if none, use 1 year ago as starting point
    start_date = last_event.nil? ? DateTime.now - 1.year : last_event.date

    # get all events
    events = github.events.received("yegrubyists")

    # filter on event type
    events.delete_if{ |event| !report_on.include?(event.type) }

    # filter on date
    events.delete_if{ |event| Time.parse(event.created_at) <= start_date }

    return events
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


