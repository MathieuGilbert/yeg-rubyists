class BlogPost < ActiveRecord::Base
  attr_accessible :title, :summary, :date, :url
  
  belongs_to :member
  
  validates :title, :summary, :date, :url, :member_id,  :presence => true

end
