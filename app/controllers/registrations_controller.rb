class RegistrationsController < Devise::RegistrationsController
  before_filter :setup_negative_captcha, :only => [:new, :create]

  def new
    super
  end

  def create
    @member = Member.new(params[:member].merge(@captcha.values))

    if @captcha.valid? && @member.save
      # the member has passed validation so we need to save their avatar
      Delayed::Job.enqueue MemberJob.new(params[:avatar_type], @member)

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
    def setup_negative_captcha
      @captcha = NegativeCaptcha.new(
        :secret => NEGATIVE_CAPTCHA_SECRET,
        :spinner => request.remote_ip,
        :fields => [:name],
        :params => params)
    end

end