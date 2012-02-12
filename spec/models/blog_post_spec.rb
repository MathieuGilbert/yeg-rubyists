require 'spec_helper'

describe BlogPost do
  before(:each) do
    @member = Factory(:member)
    @attr = { :title => "Everything Solved",
              :date => Time.at(rand * Time.now.to_i),
              :summary => "I solved everything with these 3 weird old tips.",
              :url => "http://www.blog.com/sample" }
  end
  
  it "should create an instance given valid attributes" do
    @member.blog_posts.create!(@attr)
  end
  
  it "should require a date" do
    @member.blog_posts.build(@attr.merge(:date => "")).should_not be_valid
  end
  
  it "should require a title" do
    @member.blog_posts.build(@attr.merge(:title => "")).should_not be_valid
  end
  
  it "should require a url" do
    @member.blog_posts.build(@attr.merge(:url => "")).should_not be_valid
  end
  
  it "should require an associated member" do
    BlogPost.new(@attr).should_not be_valid
  end
  
  it "should associate the post to the correct user" do
    blog_post = @member.blog_posts.build(@attr)
    blog_post.member_id.should == @member.id
  end
end
