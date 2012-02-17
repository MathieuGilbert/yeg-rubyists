class GitEventsController < ApplicationController
  respond_to :json
  
  def index
    DataParser.update_data
    git_events = GitEvent.where('date > ?', params[:date]).order("date DESC")
        
    respond_with(git_events) do |format|
      format.json { render :json => git_events }
    end
  end
end
