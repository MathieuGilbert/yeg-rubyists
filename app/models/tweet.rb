class Tweet < ActiveRecord::Base
  attr_accessible :user_screen_name, :user_description, :user_location, :user_followers_count, :text, 
                  :retweet_count, :user_profile_image_url

end
