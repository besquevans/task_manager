class UsersController < ApplicationController
  def sign_up
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to tasks_path, notice: I18n.t("user.sign_up_success")
    else
      render :sign_up
    end
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
