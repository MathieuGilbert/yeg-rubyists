class BlogPostsController < ApplicationController
  respond_to :json
  
  def index
    DataParser.update_data
    blog_posts = BlogPost.where('date > ?', params[:date]).order("date DESC")
        
    respond_with(blog_posts) do |format|
      format.json { render :json => blog_posts }
    end
  end
end
