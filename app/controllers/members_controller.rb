class MembersController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_member!, :only => [:administer, :approve]
  before_filter :admin_member, :only => [:administer]
  
  def administer
    @members = Member.find(:all, :conditions => { :status => "pending" })
  end
  
  def approve
    # approve the member
    member = Member.find(params[:id])
  
    # add the member to the twitter list
    if !member.twitter.empty?
      add_to_twitter_list(member)
    end
    
    member.update_attributes({:status => 'approved'})
    redirect_to(admin_path)
  end
  
  # method to make sure the username is unique
  def check_username
    @member = Member.find(:first, :conditions => [ "lower(name) = ?", params[:member][:name].downcase ])
    respond_with(@member)
  end
  
  def check_account(type, username)
    
    
  end
  
  
  
  private
    def admin_member
      redirect_to(root_path) unless current_member.admin?
    end
    
    def add_to_twitter_list(member)
      # grab the twitter list
      twitter = Twitter::Client.new
      twitter_list = twitter.list_timeline('yegrb-members')
      
      # add twitter user to yeg-members list to start monitoring tweets
      twitter.list_add_member('yegrb-members', member.twitter)
    end
    
end
