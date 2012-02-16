class DataParser
# get all member accounts
# for each twitter account
#   retrieve most recent 10 tweets
#   commit them to the database

  def self.update_data
    # grab all of the members
    members = Member.all

    # update tweets table
    self.update_tweets(members)
    
    #update git
    #update blogs
  end

  def self.update_tweets(members)
    if !members.empty?
        # grab the most recent tweet
        last_updated_tweet = Tweet.order("since_id desc").first

        # grab the newest tweets from the yeg-members list
        twitter_rest = RestClient::Resource.new "https://api.twitter.com/1/yeg_rubyists/lists/yegrb-members/statuses.atom?&include_rts=true&count=10&since_id=#{last_updated_tweet.since_id}"
        twitter_feed = SimpleRSS.parse ( twitter_rest.get )

        # loop through each newest tweet
        twitter_feed.items.each do |new_tweet|
          # compare the tweet user name vs the new tweet username
          
          members.each do |member|
            tweet_found = false
            
            # break up the username and content from the tweet
            # i think there's an easier way to do this, assign multiple vars with regex groups
            tweet_breakup = new_tweet.title.scan(/(^.*):(.*)/i)
            username = tweet_breakup[0][0]
            content = tweet_breakup[0][1]
            
            # check if usernames are equal (case insensitive)
            if member.twitter.casecmp(username)
              
              # now that we know who it belongs to we need to parse the rest of the data
              # since_id & url => <id>tag:twitter.com,2007:http://twitter.com/RyanOnRails/statuses/169502418399264769</id>
              # date => <published>2012-02-14T19:25:00+00:00</published>
              
              # create tweet
              member.tweet.create!({
                :date    => new_tweet.published,
                :content => content,
                :url     => new_tweet.id});
                
              tweet_found = true
            end
            
            # if a match is found for the tweet break out of this loop
            break if tweet_found == true
          end
        end
        
    nil    # make sure to have begin rescue
    end 
  end

end


