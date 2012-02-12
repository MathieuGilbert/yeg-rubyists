class PagesController < ApplicationController
  def index
    # Get the most recent 25 tweets
    @tweets = Tweet.order("date desc").limit(25)
  end
end
