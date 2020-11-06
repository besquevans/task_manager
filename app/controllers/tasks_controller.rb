class TasksController < ApplicationController
  before_action :find_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = Task.ransack(params[:q])
    @tasks = @q.result(distinct: true).order(created_at: :desc)
  end

  def show
  end

  def new
    @task = Task.new(start_at: Time.now)
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
    params.require(:task).permit(:title, :content, :start_at, :end_at, :priority, :status)
  end
end
