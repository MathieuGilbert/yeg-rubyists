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

    describe "DELETE 'destroy'" do
      it "should not delete" do
        delete :destroy
        response.should redirect_to(new_member_session_path)
      end
    end

  end
  
  describe "logged-in members" do
    before(:each) do
      sign_in(@member)
    end

    describe "DELETE 'destroy'" do
      it "should delete the member's tweets'" do
        member_id = @member.id
        delete :destroy
        Tweet.find_all_by_member_id(member_id).should be_empty
      end

      it "should delete the member's blog posts" do
        member_id = @member.id
        delete :destroy
        BlogPost.find_all_by_member_id(member_id).should be_empty
      end

      it "should delete the member's git events" do
        member_id = @member.id
        delete :destroy
        GitEvent.find_all_by_member_id(member_id).should be_empty
      end

      it "should delete the member" do
        member_id = @member.id
        delete :destroy
        Member.find_by_id(member_id).should be_nil
      end

      it "should redirect to the home page" do
        delete :destroy
        response.should redirect_to(root_path)
      end
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