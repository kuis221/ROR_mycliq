class RegistrationsController < Devise::RegistrationsController
  before_action :get_age, only: [:update]

  def update
    params[:user][:age] = get_age

    if current_user.authorizations.any?
      # required for settings form to submit when password is left blank
      clean_password if params[:user][:password].blank?
      clean_current_password
      @user = User.find(current_user.id)

      if @user.update_attributes(account_update_params)
        set_flash_message :notice, :updated
        # Sign in the user bypassing validation in case his password changed
        sign_in @user, :bypass => true
        redirect_to after_update_path_for(@user)
      else
        render "edit"
      end
    else
      super
    end
  end

  private

  def clean_password
    params[:user].delete("password")
    params[:user].delete("password_confirmation")
  end

  def clean_current_password
    params[:user].delete("current_password")
  end

  def birthday_fields_empty?
    !params[:age_] || params[:age_][:year].blank? || params[:age_][:month].blank? || params[:age_][:day].blank?
  end

  def get_age
    return nil if birthday_fields_empty?
    now = Time.now.utc.to_date
    birthday = Date.new(params[:age_][:year].to_i, params[:age_][:month].to_i, params[:age_][:day].to_i)
    now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :first_name, :last_name, :avatar)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :current_password, :age, :bio, :gender, :first_name, :last_name, :avatar)
  end
end
