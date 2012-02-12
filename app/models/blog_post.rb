class BlogPost < ActiveRecord::Base
  attr_accessible :title, :summary, :date, :url
  
  belongs_to :member
  
  validates :title,     :presence => true
  validates :summary,   :presence => true
  validates :date,      :presence => true
  validates :url,       :presence => true
  validates :member_id, :presence => true
end
