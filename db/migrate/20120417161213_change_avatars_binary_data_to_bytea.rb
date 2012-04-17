class ChangeAvatarsBinaryDataToBytea < ActiveRecord::Migration
  def up
    change_column :avatars, :binary_data, :bytea
  end

  def down
    change_column :avatars, :binary_data, :binary
  end
end
