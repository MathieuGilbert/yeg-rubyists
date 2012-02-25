class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.string :description
      t.string :content_type
      t.string :filename
      t.binary :binary_data

      t.timestamps
    end
  end
end
