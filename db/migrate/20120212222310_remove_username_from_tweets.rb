class RemoveUsernameFromTweets < ActiveRecord::Migration
  def change
    remove_column :tweets, :username
  end
end
