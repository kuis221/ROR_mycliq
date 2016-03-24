class RegistrationsController < Devise::RegistrationsController
  before_action :get_age, only: [:update]

  def update
    params[:user][:age] = get_age
    super
  end

  private

  def get_age
    return nil if params[:age_][:year].blank? || params[:age_][:month].blank? || params[:age_][:day].blank?
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
