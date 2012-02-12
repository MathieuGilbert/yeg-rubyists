class CreateGitEvents < ActiveRecord::Migration
  def change
    create_table :git_events do |t|
      t.string :username
      t.string :date
      t.string :event
      t.integer :member_id

      t.timestamps
    end
  end
end
