class Users::InvitationsController < Devise::InvitationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def create
    params[:user][:username] = SecureRandom.urlsafe_base64(nil, false)
    super
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:username, :first_name, :email, :password, :password_confirmation, :invitation_token)
    end
    devise_parameter_sanitizer.for(:invite).push(:username)
  end
end
