require 'spec_helper'

describe MembersController do
  before(:each) do
    @member = Factory(:member)
  end
  

  describe "administrator access" do
    it "should deny non admins access to /admin" do
      sign_in(@member)
      get :administer
      response.should redirect_to(root_path)
    end
    
    it "should allow admins to access /admin" do
      @member.toggle!(:admin)
      sign_in(@member)
      get :administer
      response.should be_success
    end
    
  end
  
end