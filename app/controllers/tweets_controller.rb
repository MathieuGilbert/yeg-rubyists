class TweetsController < ApplicationController
  respond_to :json
  
  def index
    # update tweets, git_events and blogrss 
    DataParser.update_data
    
    # grab all of the tweets since the most recent tweet
    tweets = Tweet.where('date > ?', params[:date]).order("date DESC")
        
    respond_with(tweets) do |format|
      format.json { render :json => tweets({:methods => :member_name}) }
    end
  end
  
  def show
    # grab a single tweet from the db
    tweet = Tweet.find(params[:id])
    
    respond_with(tweet) do |format|
      format.json { render :json => tweet.to_json({:methods => :member_name}) }
    end
  end
end
