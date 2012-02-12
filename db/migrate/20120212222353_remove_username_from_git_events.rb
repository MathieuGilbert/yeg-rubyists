class RemoveUsernameFromGitEvents < ActiveRecord::Migration
  def change
    remove_column :git_events, :username
  end

end
