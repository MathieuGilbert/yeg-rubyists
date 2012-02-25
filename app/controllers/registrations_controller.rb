class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end
  
  def create
    puts params.to_json
    @member = Member.new(params[:member])
    if @member.save
      # the member has passed validation so we need to save their avatar
      puts params[:avatar_type]
      create_member_avatar(params[:avatar_type], @member)
      redirect_to root_path
    else
      render :action => "new"
    end
  end

  def update
    super
  end
  
private
  def create_member_avatar(avatar_type, member)
    if avatar_type == "Twitter"
      image = RestClient.get "http://a0.twimg.com/profile_images/1764782745/RJ_normal.jpg"
      new_avatar = Avatar.create!({:description => 'test',
                             :content_type => image.headers[:content_type], 
                             :filename => 'twitter', 
                             :binary_data => image.body})
                             
      # assign the avatar to the member
      member.avatar = new_avatar
    end
    
    
    
  end
  
  
end 