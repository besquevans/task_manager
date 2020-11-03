class AddValidatesToTasks < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tasks, :title, false
    change_column_null :tasks, :start_at, false

    remove_column :tasks, :priority, :string
    remove_column :tasks, :status, :string

    add_column :tasks, :priority, :int, default: 1, null: false
    add_column :tasks, :status, :int, default: 0, null: false
  end
end
