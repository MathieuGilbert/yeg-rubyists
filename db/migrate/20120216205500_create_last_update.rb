class CreateLastUpdate < ActiveRecord::Migration
  def change
    create_table :last_updates do |t|
      t.datetime :twitter
      t.datetime :github
      t.datetime :blog

      t.timestamps
    end
  end
end
