class Tweet < ActiveRecord::Base
  attr_accessible :username, :date, :content, :url

  belongs_to :member
  
  validates :username , :presence => true
  # validates :date 
  # validates :content 
  # validates :url 
  # validates :member_id
  
end
