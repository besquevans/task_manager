class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user, :admin?
  before_action :authorized

  def current_user
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    redirect_to sign_in_users_path unless logged_in?
  end

  def admin?
    current_user.role == "admin"
  end
end
