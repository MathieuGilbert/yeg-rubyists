class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.string :summary
      t.string :date
      t.integer :member_id      

      t.timestamps
    end
  end
end
