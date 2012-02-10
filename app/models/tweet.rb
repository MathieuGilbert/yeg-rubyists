class Tweet < ActiveRecord::Base
  attr_accessible :username, :date, :content, :url

end
