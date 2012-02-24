class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end
  
  def create
    @member = Member.new(params[:member])
    if @member.save
      redirect_to root_path
    else
      render :action => "new"
    end
  end

  def update
    super
  end
  
end 