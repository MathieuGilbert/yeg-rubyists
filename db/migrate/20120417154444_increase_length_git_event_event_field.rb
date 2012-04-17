class IncreaseLengthGitEventEventField < ActiveRecord::Migration
  def up
    change_column :git_events, :event, :text, :limit => 1000
  end

  def down
    change_column :git_events, :event, :text, :limit => 255
  end
end
