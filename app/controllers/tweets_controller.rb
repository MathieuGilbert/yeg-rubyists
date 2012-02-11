class TweetsController < ApplicationController
  respond_to :json
  
  def index
    # need to be able to handle something like this:
    # return ('/tweets?from_time=' + this.models[this.models.length-1].get("created_at"));
    
    @tweets = Tweet.all
    
    respond_with(@tweets) do |format|
      format.json { render :json => @tweets }
    end
  end
end
