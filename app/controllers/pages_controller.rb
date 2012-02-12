class PagesController < ApplicationController
  def index
    @tweets = Tweet.order("date desc").limit(25)
  end
end
