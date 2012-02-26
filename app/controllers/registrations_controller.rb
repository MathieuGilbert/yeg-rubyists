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
    puts 'here2'
    puts avatar_type
    if avatar_type == "Twitter"
      puts 'here1'
      # get the profile image from twitter
      profile_image_url = twitter_img_url(member.twitter)
      puts 'here3'
      puts profile_image_url
      if !profile_image_url.empty?
        # go out and grab the image
        image = RestClient.get profile_image_url

        # create the new image blobbers
        new_avatar = Avatar.create!({:description => 'test',
                               :content_type => image.headers[:content_type], 
                               :filename => 'twitter', 
                               :binary_data => image.body})
                               
        # assign the avatar to the member
        member.avatar = new_avatar
      end
    end
    
    #if github
    
    
    
  end
    
  def twitter_img_url(twitter_username)
    # get the twitter feed in XML since simple rss ignore the fields we need
    h = Hpricot.XML(RestClient.get "http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=#{twitter_username}&include_rts=true&count=1")
    
    # grab the profile image url
    profile_image_url = h.search("profile_image_url").inner_html
  end

end 