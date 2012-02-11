class PagesController < ApplicationController
  def index
    @tweets = Tweet.all
  end
end
