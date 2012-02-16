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
            username, content = new_tweet.title.match(/(^.*): (.*)/i).captures
            
            # check if usernames are equal (case insensitive)
            if member.twitter.casecmp(username)
              
              # pull out url, since_id and published_at
              url, since_id = new_tweet.id.match(/(h.*\/)(.*)/).captures
              published_dt = Time.parse(new_tweet.published.to_s)
              
              # create tweet
              member.tweets.create!({
                :date     => published_dt,
                :content  => content,
                :url      => url,
                :since_id => since_id})
                
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


