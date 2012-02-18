class GitEventsController < ApplicationController
  respond_to :json
  
  def index
    DataParser.update_data
    git_events = GitEvent.where('date > ?', params[:date]).order("date DESC")
        
    respond_with(git_events) do |format|
      format.json { render :json => git_events({:methods => :github_member}) }
    end
  end

  def show
    git_event = GitEvent.find(params[:id])
    
    respond_with(git_event) do |format|
      format.json { render :json => git_event({:methods => :github_member}) }
    end
  end

  # Create github app
  # Now your "shell account" (yegrubyists in this case) needs to be authenticated to the app
  # Comment out the routes to these
  # Go to url/authorize to auth your github account
  # make sure your github app callbacks are setup correctly
  # once a key is gotten it should last forever (it would be something that you'd store in the DB)
  # yegrubyists current oauth token is this: 976899e48b64482df1c6062f0416b4f10f6e139c
  def authorize
    @github = Github.new
    address = @github.authorize_url :redirect_uri => 'http://96.52.188.123:3000/github_auth', :scope =>  'user'
    redirect_to address
  end

  def github_auth
    github = Github.new
    authorization_code = params[:code]
    token = github.get_token authorization_code
    access_token = token.token

    render :text => access_token.to_s
  end

end
