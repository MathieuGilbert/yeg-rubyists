class RemoveUrlFromGitEvents < ActiveRecord::Migration
  def self.up
    remove_column :git_events, :url
  end
end
