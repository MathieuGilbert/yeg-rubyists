class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :username
      t.string :date
      t.string :content
      t.string :url

      t.timestamps
    end
  end
end
