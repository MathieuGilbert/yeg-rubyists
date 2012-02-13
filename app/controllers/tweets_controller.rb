class TweetsController < ApplicationController
  respond_to :json
  
  def index
    tweets = Tweet.where('date > ?', params[:date]).order("date DESC")
        
    respond_with(tweets) do |format|
      format.json { render :json => tweets }
    end
  end
end
