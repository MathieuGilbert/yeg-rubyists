class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end
  
  def create
    @member = Member.new(params[:member])
    
    if @member.save
      # the member has passed validation so we need to save their avatar
      create_member_avatar(params[:avatar_type], @member)
      
      # sign the user in
      sign_in @member
      
      # send em home
      redirect_to root_path
    else
      render :action => "new"
    end
  end

  def update
    # update the member
    @member = current_member
    
    # update without pass
    if params[:member][:password].blank?
      params[:member].delete(:password)
      params[:member].delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    # update member
    if @member.update_attributes(params[:member]) 
      
      # delete avatar if it exists to keep db clean
      unless @member.avatar.nil?
        avatar = @member.avatar
        avatar.delete
      end
      
      # the member has passed validation so we need to save their avatar
      create_member_avatar(params[:member][:avatar_type], @member)
      
      # sign the user in
      sign_in @member
      
      # set the users status to pending so we can approve it again
      @member.update_attributes({:status => 'pending'}) 
      
      # send em home
      redirect_to root_path
    else
      # update failed
      render :action => "edit"
    end
    
  end
  
private
  def create_member_avatar(avatar_type, member)
    
    if avatar_type == "Twitter"
      # create twitter avatar and apply to member
      save_avatar(twitter_img_url(member.twitter), member)
    end
    
    if avatar_type == "Gravatar"
      # create gravatar avatar and apply to member
      save_avatar(gravatar_img_url(member.email), member)
    end
  end
  
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