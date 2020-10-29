class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :content
      t.datetime :start_at
      t.datetime :end_at
      t.string :priority, default: "中"
      t.string :status, default: "待處理"

      t.timestamps
    end
  end
end
