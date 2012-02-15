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
    if !member.twitter.empty?
      begin
        Tweets.order("since_id desc").first
        
        # grab the members last 10 tweets
        twitter_feed = RestClient::Resource.new "view-source:https://api.twitter.com/1/yeg_rubyists/lists/yegrb-members/statuses.atom?&include_rts=true&count=10"
        SimpleRSS.parse ( twitter_feed.get )

        # loop through and compare all tweets
        twitter_feed.items.each do |new_tweet|
          tweet_found = false

          current_tweets.items.each do |current_tweet|
            # check if the tweet exists
            if current_tweet.title == new_tweet.title
              tweet_found = true
            end
          end
          puts 'tweet ' + tweet_found
          # tweet wasn't found, add it to the db
          if tweet_found == false
            puts 'Adding Tweet'
            member.tweet.create!({
              :date    => new_tweet.published,
              :content => new_tweet.title,
              :url     => new_tweet.id
            });
          end
        end  

      rescue
        # 404 -> twitter handle not found
        # 400 -> reached limit of 150 an hour
      end
    end 
    
  end

end


