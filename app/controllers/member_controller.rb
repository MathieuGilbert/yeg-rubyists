class MemberController < ActionController::Base
  before_filter :authenticate_member!
  before_filter :admin_member, :only => [:administer]
  
  def administer
    # uncomment to give yourself admin:
    current_member.update_attribute :admin, true
    @members = Member.find(:all, :conditions => { :status => "pending" })
  end

  private
    def admin_member
      redirect_to(root_path) unless current_member.admin?
    end
    
end
