class AddSinceIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :since_id, :integer
  end
end
