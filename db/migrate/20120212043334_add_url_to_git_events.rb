class AddUrlToGitEvents < ActiveRecord::Migration
  def change
    add_column :git_events, :url, :string

  end
end
