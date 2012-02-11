class Tweet < ActiveRecord::Base
  attr_accessible :username, :date, :content, :url

  belongs_to :member
  
  validates :username,  :presence => true
  validates :date,      :presence => true
  validates :content,   :presence => true
  validates :url,       :presence => true
  validates :member_id, :presence => true
  
end
