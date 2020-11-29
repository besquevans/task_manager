class TasksController < ApplicationController
  before_action :find_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result.includes(:tags).page(params[:page]).per(5).order(created_at: :desc)
  end

  def show
  end

  def new
    @task = Task.new(start_at: Time.zone.now, end_at: Time.zone.now + 1.day)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: I18n.t("task.create_success")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: I18n.t("task.update_success")
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, alert: I18n.t("task.delete_success")
  end

  private

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :start_at, :end_at, :priority, :status, tag_list: []).merge!(user: current_user)
  end
end
