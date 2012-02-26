class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, 
                  :twitter, :github, :blogrss, :status, :avatar_type

  validates :name,  :presence => true
  validate :social_media_supplied
  validate :email_check
  validate :twitter_check
  validate :github_check
  validate :blogrss_check
  
  has_many :tweets, :dependent => :destroy
  has_many :git_events, :dependent => :destroy
  has_many :blog_posts, :dependent => :destroy
  
  # Relationships
  has_one :avatar
  
  def social_media_supplied
    if twitter.empty? and github.empty? and blogrss.empty?
      errors.add :base, "At least 1 social media link is required."
    end
  end
  
  # method to make sure the email is in the correct format
  def email_check
    if !email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
      errors.add :base, "Email is in an invalid format."
    end
  end
  
  # check if the twitter account is legit
  def twitter_check
    begin
      if !twitter.empty?
        RestClient.get "twitter.com/#{twitter}"
      end
    rescue => e
      errors.add :base, "Invalid Twitter account."
    end
  end
  
  # check if the github account is legit
  def github_check
    begin
      if !github.empty?
        RestClient.get "github.com/#{github}"
      end
    rescue => e
      errors.add :base, "Invalid Github account."
    end
  end
  
  # check if the blog rss url is legit
  def blogrss_check
    begin
      if !blogrss.empty?
        RestClient.get blogrss
      end
    rescue => e
      errors.add :base, "Invalid Blog URL"
    end
  end


end
