require "rails_helper"

RSpec.feature "Sort tasks", type: :feature, driver: :chrome, js: true, slow: true do
  before(:each) do
    visit sign_up_users_path
    fill_in :user_email,	with: "user1@mail.com"
    fill_in :user_password,	with: "123456"
    fill_in :user_password_confirmation,	with: "123456"
    click_button(I18n.t("user.sign_up"))
    @user = User.first
  end

  context "created_at" do
    it "default sort" do
      (1..5).each do |i|
        create(:task, title: "Task #{i}", user: @user)
      end
      visit tasks_path

      task_names = page.all("td.task-title").map(&:text)
      expect(task_names).to eq(["Task 5", "Task 4", "Task 3", "Task 2", "Task 1"])
    end
  end

  context "end_at" do
    it "click link and sort" do
      create(:task, user: @user, title: "Task 1", end_at: Time.zone.now)
      create(:task, user: @user, title: "Task 2", end_at: Time.zone.now + 2.day)
      create(:task, user: @user, title: "Task 3", end_at: Time.zone.now + 1.day)
      visit tasks_path

      task_names = page.all("td.task-title").map(&:text)
      expect(task_names).to eq(["Task 3", "Task 2", "Task 1"])

      expect(page.find(".end_at a").text).to eq(I18n.t("task.end_at"))
      click_link(I18n.t("task.end_at"))
      sleep(0.1)
      task_names = page.all("td.task-title").map(&:text)
      expect(task_names).to eq(["Task 1", "Task 3", "Task 2"])
    end
  end

  context "priority" do
    it "click link and sort" do
      create(:task, user: @user, title: "Task 1", priority: 1)
      create(:task, user: @user, title: "Task 2", priority: 0)
      create(:task, user: @user, title: "Task 3", priority: 2)

      visit tasks_path

      task_names = page.all("td.task-title").map(&:text)
      expect(task_names).to eq(["Task 3", "Task 2", "Task 1"])

      expect(page.find(".priority a").text).to eq(I18n.t("task.priority"))
      click_link(I18n.t("task.priority"))
      sleep(0.1)
      task_names = page.all("td.task-title").map(&:text)
      expect(task_names).to eq(["Task 3", "Task 1", "Task 2"])
    end
  end
end
