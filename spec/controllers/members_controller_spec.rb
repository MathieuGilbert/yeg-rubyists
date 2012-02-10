require 'spec_helper'

describe MembersController do
  before(:each) do
    @member = Factory(:member)
  end
  
<<<<<<< HEAD

  describe "administrator access" do
    it "should be denied to regular members" do
      sign_in(@member)
=======
  describe "public users" do
    it "should protect the admin page" do
>>>>>>> 7b3be4741773c98028e0ad29867dd58fe7f69374
      get :administer
      response.should redirect_to(root_path)
    end  
  end
  
  describe "logged-in members" do
    before(:each) do
      sign_in(@member)
    end
    
<<<<<<< HEAD
    it "should allow be granted to administrators" do
      @member.toggle!(:admin)
      sign_in(@member)
      get :administer
      response.should be_success
=======
    describe "non-admins" do
      it "should deny non admins access to /admin" do
        get :administer
        response.should redirect_to(root_path)
      end
>>>>>>> 7b3be4741773c98028e0ad29867dd58fe7f69374
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