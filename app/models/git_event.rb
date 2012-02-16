class GitEvent < ActiveRecord::Base
  attr_accessible :date, :event, :url
  
  belongs_to :member
  
  validates :date, :event, :url, :member_id, :presence => true
  
end
