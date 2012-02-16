# this is the main class that parses the data before putting it in the DB
class DataParser
  def self.update_data
    last_update = self.get_lastest_update
    
    # Check when the last update has been fired, if it's > 2 minutes, it can fire again
    # This is to to prevent getting banned from the service APIs
    if last_update.time < (DateTime.now.new_offset(0) - 30.seconds)
      # grab all of the members
      members = Member.all
  
      # update tweets table
      self.update_tweets(members)
    
      #update git
      #update blogs
      last_update.update_attributes({:time => DateTime.now.new_offset(0)})
    end
  end

  def self.update_tweets(members)
    begin
      # make sure we have members to match against
      if !members.empty?
          # grab the most recent tweet
          last_updated_tweet = Tweet.order("since_id desc").first
          
          # If there are no since_id's in the db, we go and get all of the possible tweets
          if last_updated_tweet.nil?
            twitter_rest = RestClient::Resource.new "https://api.twitter.com/1/yeg_rubyists/lists/yegrb-members/statuses.atom?&include_rts=true"
            twitter_feed = SimpleRSS.parse ( twitter_rest.get )
          else
            # grab the newest tweets from the yeg-members list based on the since_id
            twitter_rest = RestClient::Resource.new "https://api.twitter.com/1/yeg_rubyists/lists/yegrb-members/statuses.atom?&include_rts=true&since_id=#{last_updated_tweet.since_id}"
            twitter_feed = SimpleRSS.parse ( twitter_rest.get )
          end
  
          # loop through each new tweet
          twitter_feed.items.each do |new_tweet|
            # break up the username and content from the tweet
            # i think there's an easier way to do this, assign multiple vars with regex groups
            username, content = new_tweet.title.match(/(^[^\:]*): (.*)/i).captures
            
            # compare the tweet user name vs the new tweet username
            members.each do |member|
              tweet_found = false
  
              # check if usernames are equal (case insensitive)
              if member.twitter.casecmp(username) == 0
  
                # pull out url, since_id and published_at
                url, since_id = new_tweet.id.match(/(http.*\/)(.*)/).captures
                published_dt = Time.parse(new_tweet.published.to_s)
                
                # create tweet
                member.tweets.create!({
                  :date     => published_dt,
                  :content  => content,
                  :url      => url + since_id.to_s,
                  :since_id => since_id})
                  
                tweet_found = true
              end
              
              # if a match is found for the tweet break out of this loop
              break if tweet_found == true
            end
          end
      end
    rescue
        puts 'twittter failed!!'
    end 
  end

  
  
private
  def self.get_lastest_update
    # try and get the last update
    last_update = LastUpdate.first
    
    # Make sure the last update exists
    if last_update.nil?
      last_update = LastUpdate.create!({:time => DateTime.now.new_offset(0)})
    end
    
    last_update
  end

end


