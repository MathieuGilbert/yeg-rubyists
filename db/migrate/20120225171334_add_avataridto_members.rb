class AddAvataridtoMembers < ActiveRecord::Migration
  def change
    add_column :members, :avatar_id, :integer
  end
end
