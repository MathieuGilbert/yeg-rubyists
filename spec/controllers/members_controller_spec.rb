require 'spec_helper'

describe MembersController do
  before(:each) do
    @member = Factory(:member)
  end
  
  describe "public users" do
    it "should protect the admin page" do
      get :administer
      response.should redirect_to(new_member_session_path)
    end

  end
  
  describe "logged-in members" do
    before(:each) do
      sign_in(@member)
    end

    describe "non-admins" do
      it "should deny non admins access to /admin" do
        get :administer
        response.should redirect_to(root_path)
      end
    end
    
    describe "admins" do
      before(:each) do
        @member.toggle!(:admin)
      end
      
      it "should allow admins to access /admin" do
        get :administer
        response.should be_success
      end
    end
  end


  
end