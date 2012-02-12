class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, 
                  :twitter, :github, :blogrss, :status
  
  validates :name,  :presence => true
  validate :social_media_supplied
  
  has_many :tweets, :dependent => :destroy
  has_many :git_events, :dependent => :destroy
  has_many :blog_posts, :dependent => :destroy
  
  def social_media_supplied
    if twitter.empty? and github.empty? and blogrss.empty?
      errors.add :base, "At least 1 social media link is required."
    end
  end
  

end
