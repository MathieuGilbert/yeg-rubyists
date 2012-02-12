class GitEvent < ActiveRecord::Base
  attr_accessible :username, :date, :event, :url
  
  belongs_to :member
  
  validates :username,  :presence => true
  validates :date,      :presence => true
  validates :event,     :presence => true
  validates :url,       :presence => true
  validates :member_id, :presence => true
  
end
