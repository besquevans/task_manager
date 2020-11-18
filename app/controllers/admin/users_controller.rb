class Admin::UsersController < ApplicationController
  before_action :admin_authorized
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
    @q = @user.tasks.ransack(params[:q])
    @tasks = @q.result.page(params[:page]).per(5).order(created_at: :desc)
    render template: "tasks/index"
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: I18n.t("user.create_success")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: I18n.t("user.update_success")
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: I18n.t("user.delete_success")
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def admin_authorized
    if current_user.role != "admin"
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
