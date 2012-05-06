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
  validate :avatar_check
  
  has_many :tweets, :dependent => :destroy
  has_many :git_events, :dependent => :destroy
  has_many :blog_posts, :dependent => :destroy
  
  # Relationships
  has_one :avatar
  
  def social_media_supplied
    if twitter.blank? and github.blank? and blogrss.blank?
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
      unless twitter.blank?
        RestClient.get "twitter.com/#{twitter}"
      end
    rescue
      errors.add :base, "Invalid Twitter account."
    end
  end
  
  # check if the github account is legit
  def github_check
    begin
      unless github.blank?
        RestClient.get "https://github.com/#{github}"
      end
    rescue
      errors.add :base, "Invalid Github account."
    end
  end
  
  # check if the blog rss url is legit
  def blogrss_check
    begin
      unless blogrss.blank?
        RestClient.get blogrss
      end
    rescue
      errors.add :base, "Invalid Blog URL"
    end
  end

  def avatar_check
    if avatar_type == "Twitter" && twitter.blank?
      errors.add :base, "You must have a twitter username to set as your profile image."
    end
  end

  def create_member_avatar(avatar_type, member)

    #lets get some error handling up in hurr
    begin
      if avatar_type == "Twitter"
        # create twitter avatar and apply to member
        save_avatar(twitter_img_url(member.twitter), member)
      end

      if avatar_type == "Gravatar"
        # create gravatar avatar and apply to member
        save_avatar(gravatar_img_url(member.email), member)
      end
    rescue => error
      error.to_s
    end
  end

  private

    def save_avatar(image_url, member)
      unless image_url.empty?
        # go out and grab the image
        image = RestClient.get image_url

        # create the new image blobbers
        new_avatar = Avatar.create!({:description => '',
                                     :content_type => image.headers[:content_type],
                                     :filename => member.name,
                                     :binary_data => image.body})

        # assign the avatar to the member
        member.avatar = new_avatar
      end
    end

    def gravatar_img_url(gravatar_email)
      # generate gravatar md5 and return the url
      gravatar_MD5 = Digest::MD5.hexdigest(gravatar_email.to_s.downcase)
      gravatar_url = "http://www.gravatar.com/avatar/#{gravatar_MD5}.png"
    end

    def twitter_img_url(twitter_username)
      # get the twitter feed in XML since simple rss ignore the fields we need
      h = Hpricot.XML(RestClient.get "http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=#{twitter_username}&include_rts=true&count=1")

      # grab the profile image url
      profile_image_url = h.search("profile_image_url").inner_html
    end


end
