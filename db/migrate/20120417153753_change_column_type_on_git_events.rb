class ChangeColumnTypeOnGitEvents < ActiveRecord::Migration
  def up
    change_column :git_events, :event, :text
  end

  def down
    change_column :git_events, :event, :string
  end
end
