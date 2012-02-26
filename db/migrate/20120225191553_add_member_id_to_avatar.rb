class AddMemberIdToAvatar < ActiveRecord::Migration
  def change
    add_column :avatars, :member_id, :integer
  end
end
