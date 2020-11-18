class AddTasksCountToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tasks_count, :integer, default: 0
  end
end
