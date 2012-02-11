class TweetsController < ApplicationController
  respond_to :json
  
  def index
    @tweets = Tweet.all
    
    respond_with(@tweets) do |format|
      format.json { render :json => @tweets }
    end
  end
end
