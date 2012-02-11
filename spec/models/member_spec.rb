require 'spec_helper'

describe Member do
  before(:each) do
    @attr = { :name                  => "Test User",
              :email                 => "member@example.com",
              :password              => "password",
              :password_confirmation => "password",
              :twitter               => "http://www.twitter.com",
              :github                => "http://www.github.com",
              :blogrss               => "http://www.google.com",
              :status                => "pending" }
  end
  
  it "should create a member given valid attributes" do
    member = Member.create!(@attr)
  end

  it "should require a name" do
    Member.new(@attr.merge(:name => "")).should_not be_valid
  end
  
  it "should require at least 1 social link" do
    Member.new(@attr.merge(:twitter => "",
                           :github  => "",
                           :blogrss => "")).should_not be_valid
  end
  
  it "should default to non-admin" do
    Member.new(@attr).admin.should == false
  end
    
  describe "email validation" do
    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        Member.new(@attr.merge(:email => address)).should be_valid 
      end
    end
    
    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com THE_USER_at_foo.bar.org first.last@foo]
      addresses.each do |address|
        Member.new(@attr.merge(:email => address)).should_not be_valid
      end
    end
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
