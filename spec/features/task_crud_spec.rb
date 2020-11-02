require "rails_helper"

RSpec.feature "Read task", :type => :feature do

  context "index" do
    it "create 2 tasks" do
      task1 = create(:task)
      task2 = create(:task)

      expect(Task.all.to_a).to eq([task1, task2])
    end

    it "read 2 tasks" do
      task1 = create(:task)
      task2 = create(:task)
      visit root_path

      expect(page).to have_content("Test Task", count: 2)
    end
  end

  context "show" do
    it "read selected task" do
      task = create(:task)
      selected_task = create :task, title: "Selected Task"
      task = create(:task)
      visit task_path(selected_task.id)
      expect(page).to have_content("Selected Task")
    end
  end

  context "new and create" do
    it "create task" do
      visit new_task_path
      fill_in :task_title,	with: "New Task"
      fill_in :task_content,	with: "New Content"
      fill_in :task_start_at,	with: Time.now
      fill_in :task_end_at,	with: Time.now + 1.day
      select "高", from: "form-priority"
      select "進行中", from: "form-status"
      click_button("送出")
      expect(page).to have_content("新增任務成功！")
    end
  end

  context "edit and update" do
    it "update task" do
      task = create(:task)
      visit edit_task_path(task)
      fill_in :task_title,	with: "New Task"
      fill_in :task_content,	with: "New Content"
      fill_in :task_start_at,	with: Time.now
      fill_in :task_end_at,	with: Time.now + 1.day
      select "高", from: "form-priority"
      select "進行中", from: "form-status"
      click_button("送出")
      expect(page).to have_content("更新任務成功！")
    end
  end

  context "destory" do
    it "destory task" do
      task = create(:task)
      selected_task = create :task, title: "Selected Task"
      task = create(:task)
      visit tasks_path
      expect(page).to have_content("Test Task", count: 2)
      expect(page).to have_content("Selected Task", count: 1)
      page.all("tbody tr")[1].click_link("Destroy")
      expect(page).to have_content("Test Task", count: 2)
      expect(page).to have_no_content("Selected Task")
      expect(page).to have_content("刪除任務成功！")
    end
  end
end
