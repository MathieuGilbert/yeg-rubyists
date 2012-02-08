require 'spec_helper'

describe Member do
  before(:each) do
    @attr = { :name => "Test User",
              :email => "member@example.com",
              :password => "password",
              :password_confirmation => "password",
              :twitter => "http://www.twitter.com",
              :github => "http://www.github.com",
              :blogrss => "http://www.google.com" }
  end
  
  it "should create a member given valid attributes" do
    Member.create!(@attr)
  end

  it "should require a name" do
    Member.new(@attr.merge(:name => "")).should_not be_valid
  end
  
  describe "email validation" do
    
  end
  
  describe "password validation" do
    it "should reject blank passwords" do
      Member.new(@attr.merge(:password => "")).should_not be_valid
    end
    
    it "should reject non-matching passwords" do
      Member.new(@attr.merge(:password_confirmation => "nomatch")).should_not be_valid
    end
  end

  
  
  

end
