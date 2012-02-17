class MembersController < ApplicationController
  before_filter :authenticate_member!
  before_filter :admin_member, :only => [:administer]
  
  def administer
    # uncomment to give yourself admin:
    #current_member.update_attribute :admin, true
    @members = Member.find(:all, :conditions => { :status => "pending" })
  end
  
  def approve
    # approve the member
    member = Member.find(params[:id])
  
    # add the member to the twitter list
    if !member.twitter.empty?
      add_to_twitter_list(member)
    end
    
    # github here
    if !member.github.empty?

    end
    
    # blog here
    if !member.blogrss.empty?

    end
    
    member.update_attributes({:status => 'approved'})
    
    redirect_to(admin_path)
  end

  private
    def admin_member
      redirect_to(root_path) unless current_member.admin?
    end
    
    def add_to_twitter_list(member, twitter)
      # grab the twitter list
      twitter = Twitter::Client.new
      twitter_list = twitter.list_timeline('yegrb-members')
      
      # add twitter user to yeg-members list to start monitoring tweets
      twitter.list_add_member('yegrb-members', member.twitter)
    end
    
end
