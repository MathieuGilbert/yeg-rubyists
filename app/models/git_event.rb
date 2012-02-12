class GitEvent < ActiveRecord::Base
  attr_accessible :date, :event, :url
  
  belongs_to :member
  
  validates :date,      :presence => true
  validates :event,     :presence => true
  validates :url,       :presence => true
  validates :member_id, :presence => true
  
end
