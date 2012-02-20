class RemoveUrlFromGitEvents < ActiveRecord::Migration
  def change
    drop_column :git_events, :url
  end
end
