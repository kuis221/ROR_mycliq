class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :first_name, :last_name, :avatar)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :current_password, :age, :bio, :gender, :first_name, :last_name, :avatar)
  end
end