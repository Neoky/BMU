class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Check if logged in user is an admin
  def admin?
    if current_user.user_level == 1
      return true
    end
    return false
  end
  
  def teller?
    if current_user.user_level == 2
      return true
    end
    return false
  end
  
  def customer?
    if current_user.user_level == 3
      return true
    end
    return false
  end
  
  protected
  
  def admin_protect
    admin?
  end

  # Had to implement this for using username instead of email for devise.
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end
