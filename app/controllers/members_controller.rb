class MembersController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_member!, :only => [:administer, :approve, :destroy]
  before_filter :admin_member, :only => [:administer]
  
  def administer
    @members = Member.where({:status => "pending"}).all
  end
  
  def approve
    # approve the member
    member = Member.find(params[:id])
  
    # add the member to the twitter list
    unless member.twitter.blank?
      add_to_twitter_list(member)
    end
    
    member.update_attributes({:status => 'approved'})
    redirect_to(admin_path)
  end
  
  # method to make sure the email is in the correct format
  def email_check
    email_legit = false
    if params[:member][:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
      email_legit = true
    end

    respond_with(email_legit)
  end
  
  # check if the twitter account is legit
  def twitter_check
    twitter_legit = false
    begin
      RestClient.get "twitter.com/#{params[:member][:twitter]}"
      twitter_legit = true
    rescue
      # 404
      twitter_legit = false
    end
    
    respond_with(twitter_legit)
  end
  
  # check if the github account is legit
  def github_check
    github_legit = false
    begin
      RestClient.get "github.com/#{params[:member][:github]}"
      github_legit = true
    rescue
      # 404
      github_legit = false
    end
    
    respond_with(github_legit)
  end
  
  # check if the blog rss url is legit
  def blogrss_check
    blogrss_legit = false
    begin
      RestClient.get params[:member][:blogrss]
      blogrss_legit = true
    rescue
      # 404
      blogrss_legit = false
    end
    
    respond_with(blogrss_legit)
  end
  
  def member_image
    # Grab members avatar (every member has to have an avatar)
    @avatar = Avatar.find_by_member_id(params[:member_id])

    # Fire it out to the screen
    @image = @avatar.binary_data
    send_data @image, :type => @avatar.content_type, :disposition => 'inline'
  end

  def destroy
    member = current_member
    member.tweets.destroy_all
    member.git_events.destroy_all
    member.blog_posts.destroy_all
    member.destroy
    redirect_to root_path
  end

  private
    def admin_member
      redirect_to(root_path) unless current_member.admin?
    end
    
    def add_to_twitter_list(member)
      # grab the twitter list
      twitter = Twitter::Client.new

      # add twitter user to yeg-members list to start monitoring tweets
      twitter.list_add_member('yegrb-members', member.twitter)
    end
    
end
