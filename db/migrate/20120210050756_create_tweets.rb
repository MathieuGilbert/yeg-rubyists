class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :screen_name
      t.string :description
      t.string :location
      t.string :followers_count
      t.string :text 
      t.integer :retweet_count
      t.string :profile_image_url

      t.timestamps
    end
  end
end
