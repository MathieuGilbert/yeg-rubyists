class AddSinceIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :since_id, :bigint
  end
end
