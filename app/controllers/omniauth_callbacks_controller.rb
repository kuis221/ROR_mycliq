class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = OmniauthCallbacks::FinderOrCreator.new(request.env['omniauth.auth']).call
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end

  def twitter
    @user = OmniauthCallbacks::FinderOrCreator.new(request.env['omniauth.auth']).call
    if @user.persisted?
      @user.skip_confirmation!
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    end
  end
end
