require 'spec_helper'

describe Tweet do
  before(:each) do
    @member = Factory(:member)
    @attr = { :date      => Time.at(rand * Time.now.to_i),
              :content   => "I like pies",
              :url       => "http://www.google.com" }
  end
  
  it "should create a tweet given valid attributes" do
    @member.tweets.create!(@attr)
  end
    
  it "should require a date" do
    @member.tweets.build(@attr.merge(:date => "")).should_not be_valid
  end
  
  it "should require content" do
    @member.tweets.build(@attr.merge(:content => "")).should_not be_valid
  end
  
  it "should require a url" do
    @member.tweets.build(@attr.merge(:url => "")).should_not be_valid
  end
  
  it "should require a member id" do
    Tweet.new(@attr).should_not be_valid
  end
  
  it "should have the correct member association" do
    tweet = @member.tweets.build(@attr)
    tweet.member_id.should == @member.id
  end
  
end
