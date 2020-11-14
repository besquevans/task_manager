class UsersController < ApplicationController
  skip_before_action :authorized, only: [:sign_up, :create, :sign_in, :login]

  def sign_up
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to tasks_path, notice: I18n.t("user.sign_up_success")
    else
      render :sign_up
    end
  end

  def sign_in
    @user = User.new
  end

  def login
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to tasks_path, notice: I18n.t("user.login_success")
    else
      flash.now[:alert] = I18n.t("user.email_or_password_invalid")
      render :sign_in
    end
  end

  def sign_out
    session[:user_id] = nil
    redirect_to sign_in_users_path, notice: I18n.t("user.sign_out_success")
  end


  private

  def user_params
    if params[:user][:password] == params[:user][:password_confirmation]
      params.require(:user).permit(:email, :password)
    else
      return
    end
  end
end
