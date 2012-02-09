class AddStatusToMembers < ActiveRecord::Migration
  def change
    add_column :members, :status, :string, :default => "pending"

  end
end
