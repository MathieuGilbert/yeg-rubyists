class CreateLastUpdate < ActiveRecord::Migration
  def change
    create_table :last_updates do |t|
      t.datetime :time

      t.timestamps
    end
  end
end
