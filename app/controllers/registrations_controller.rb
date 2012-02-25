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
      m.avatar.create!({:description => 'test',
                             :content_type => image.headers[:content_type], 
                             :filename => 'twitter', 
                             :binary_data => image.body})
    end
    
    
    
  end
  
  
end 