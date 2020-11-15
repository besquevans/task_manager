require "rails_helper"

RSpec.feature "Read task", type: :feature, driver: :chrome, js: true, slow: true  do
  before(:each) do
    visit sign_up_users_path
    fill_in :user_email,	with: "user1@mail.com"
    fill_in :user_password,	with: "123456"
    fill_in :user_password_confirmation,	with: "123456"
    click_button(I18n.t("user.sign_up"))
    @user = User.first
  end

  context "index" do
    it "create 2 tasks" do
      task1 = create(:task, user: @user)
      task2 = create(:task, user: @user)

      expect(Task.all.to_a).to eq([task1, task2])
    end

    it "read 2 tasks" do
      task1 = create(:task, user: @user)
      task2 = create(:task, user: @user)
      visit tasks_path

      expect(page).to have_content("Test Task", count: 2)
    end

    it "read only self tasks" do
      my_task = create(:task, user: @user, title: "My Task")
      other = create(:user)
      other_task = create(:task, user: other, title: "Other Task")

      visit tasks_path
      expect(page).to have_content("My Task", count: 1)
    end
  end

  context "show" do
    it "read selected task" do
      task = create(:task, user: @user)
      selected_task = create :task, title: "Selected Task"
      task = create(:task, user: @user)
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
      #高
      select(I18n.t("task.priority_option")[0], from: "form-priority")
      #進行中
      select(I18n.t("task.status_option")[1], from: "form-status")
      #送出
      click_button(I18n.t(:send))
      #notice 新增任務成功！
      expect(page).to have_content(I18n.t("task.create_success"))
    end
  end

  context "edit and update" do
    it "update task" do
      task = create(:task, user: @user)
      visit edit_task_path(task)
      fill_in :task_title,	with: "New Task"
      fill_in :task_content,	with: "New Content"
      fill_in :task_start_at,	with: Time.now
      fill_in :task_end_at,	with: Time.now + 1.day
      #高
      select(I18n.t("task.priority_option")[0], from: "form-priority")
      #進行中
      select(I18n.t("task.status_option")[1], from: "form-status")
      #送出
      click_button(I18n.t(:send))
      #notice 更新任務成功！
      expect(page).to have_content(I18n.t("task.update_success"))
    end
  end

  context "destory" do
    it "destory task" do
      task = create(:task, user: @user)
      selected_task = create :task, title: "Selected Task"
      task = create(:task, user: @user)
      visit tasks_path
      expect(page).to have_content("Test Task", count: 2)
      expect(page).to have_content("Selected Task", count: 1)
      find("tr", text: "Selected Task").click_link("Destroy")
      page.driver.browser.switch_to.alert.accept #確認刪除
      expect(page).to have_content("Test Task", count: 2)
      expect(page).to have_no_content("Selected Task")
      #notice 刪除任務成功！
      expect(page).to have_content(I18n.t("task.delete_success"))
    end
  end
end
