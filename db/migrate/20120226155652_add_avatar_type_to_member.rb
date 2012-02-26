class AddAvatarTypeToMember < ActiveRecord::Migration
  def change
    add_column :members, :avatar_type, :string
  end
end
