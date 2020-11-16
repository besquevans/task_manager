class Admin::UsersController < ApplicationController
  before_action :admin_authorized

  def index
    @users = User.page(params[:page]).per(10)
  end

  private

  def admin_authorized
    if current_user.role != "admin"
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
