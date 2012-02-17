class PagesController < ApplicationController
  def index
    # Get the most recent 25 tweets
    @tweets = Tweet.order("date desc").limit(25)
    @git_events = GitEvent.order("date desc").limit(25)
    @blog_posts = BlogPost.order("date desc").limit(25)
  end
end
