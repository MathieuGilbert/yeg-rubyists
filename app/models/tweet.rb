class Tweet < ActiveRecord::Base
  attr_accessible :date, :content, :url, :since_id

  belongs_to :member
  
  validates :date, :content, :url, :since_id, :member_id, :presence => true  
end
