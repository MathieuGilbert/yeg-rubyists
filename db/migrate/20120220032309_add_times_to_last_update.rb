class AddTimesToLastUpdate < ActiveRecord::Migration
  def change
    add_column :last_updates, :git_update, :DateTime

    add_column :last_updates, :blog_update, :DateTime

    rename_column :last_updates, :time, :tweet_update
  end
end
