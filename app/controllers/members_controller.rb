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
    member.update_attributes({:status => 'approved'})
    redirect_to(admin_path)
  end

  private
    def admin_member
      redirect_to(root_path) unless current_member.admin?
    end
    
end
