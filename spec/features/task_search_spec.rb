require "rails_helper"

RSpec.feature "Search tasks", type: :feature, driver: :chrome, js: true, slow: true do
  before(:each) do
    visit sign_up_users_path
    fill_in :user_email,	with: "user1@mail.com"
    fill_in :user_password,	with: "123456"
    fill_in :user_password_confirmation,	with: "123456"
    click_button(I18n.t("user.sign_up"))
    @user = User.first
  end

  context "title" do
    before do
      create(:task, user: @user)
      create(:task, title: "Target Task", user: @user)
      visit tasks_path
    end

    it "search target task" do
      fill_in(:q_title_cont, with: "g")
      click_button(I18n.t(:search))
      expect(all("tbody tr").length).to eq(1)
      expect(page).to have_content("Target Task")
      expect(page).to have_no_content("Test Task")
    end
  end

  context "status" do
    before do
      create(:task, status: 0, user: @user)
      create(:task, status: 1, user: @user)
      create(:task, status: 2, user: @user)
      visit tasks_path
    end

    it "search finish task" do
      select(I18n.t("task.status_option")[2], from: "q_status_eq")
      click_button(I18n.t(:search))
      #完成
      expect(find("tbody")).to have_content(I18n.t("task.status_option")[2])
      #待處理 #進行中
      expect(find("tbody")).to have_no_content(I18n.t("task.status_option")[0]).or have_no_content(I18n.t("task.status_option")[1])
    end
  end

  context "tag" do
    before do
      create(:task, title: "Task1", tag_list: "tag1")
      create(:task, title: "Task2", tag_list: "tag2")
      create(:task, title: "Task3", tag_list: "tag1, tag2")
      visit tasks_path
    end

    it "search tag1" do
      fill_in(:q_tags_name, with: "tag1")
      click_button(I18n.t(:search))
      expect(all("tbody tr").length).to eq(2)
      expect(page).to have_content("Task1")
      expect(page).to have_content("Task3")
    end

    it "search tag1 + tag2" do
      fill_in(:q_tags_name,	with: "tag1 tag2")
      click_button(I18n.t(:search))
      expect(all("tbody tr").length).to eq(1)
      expect(page).to have_content("Task3")
    end
  end
end
