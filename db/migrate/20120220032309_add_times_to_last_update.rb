class AddTimesToLastUpdate < ActiveRecord::Migration
  def change
    add_column :last_updates, :git_update, :datetime

    add_column :last_updates, :blog_update, :datetime

    rename_column :last_updates, :time, :tweet_update
  end
end
