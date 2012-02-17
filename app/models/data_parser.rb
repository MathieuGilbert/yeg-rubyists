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
      # create twitter client
      twitter = Twitter::Client.new
      
      # make sure we have members to match against
      if !members.empty?
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


