class AddMemberIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :member_id, :integer
  end
end
