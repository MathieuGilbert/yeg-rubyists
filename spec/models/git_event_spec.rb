require 'spec_helper'

describe GitEvent do
  before(:each) do
    @member = Factory(:member)
    @attr = { :date => Time.at(rand * Time.now.to_i),
              :event => "Pushed to project waffle/sauce.",
              :url => "http://www.github.com/sample" }
  end
  
  it "should create an instance given valid attributes" do
    @member.git_events.create!(@attr)
  end
  
  it "should require a date" do
    @member.git_events.build(@attr.merge(:date => "")).should_not be_valid
  end
  
  it "should require an event" do
    @member.git_events.build(@attr.merge(:event => "")).should_not be_valid
  end
  
  it "should require a url" do
    @member.git_events.build(@attr.merge(:url => "")).should_not be_valid
  end
    
  it "should require an associated member" do
    GitEvent.new(@attr).should_not be_valid
  end
  
  it "should associate the event to the correct user" do
    git_event = @member.git_events.build(@attr)
    git_event.member_id.should == @member.id
  end
  
  
end
