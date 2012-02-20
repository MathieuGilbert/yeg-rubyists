class GitEvent < ActiveRecord::Base
  attr_accessible :date, :event
  
  belongs_to :member
  
  validates :date, :event, :member_id, :presence => true
  
  def github_member
    member
  end
end
