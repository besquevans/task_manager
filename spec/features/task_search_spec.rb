require "rails_helper"

RSpec.feature "Search tasks", type: :feature, driver: :chrome, js: true, slow: true do
  before(:each) do
    @user = create(:user)
  end

  context "title" do
    it "search target task" do
      create(:task, user: @user)
      create(:task, title: "Target Task", user: @user)

      visit tasks_path
      expect(page).to have_content("Test Task", count: 1)
      expect(page).to have_content("Target Task")

      fill_in(:q_title_cont, with: "g")
      click_button(I18n.t(:search))
      expect(all("tbody tr").length).to eq(1)
      expect(page).to have_content("Target Task")
      expect(page).to have_no_content("Test Task")
    end
  end

  context "status" do
    it "search finish task" do
      create(:task, status: 0, user: @user)
      create(:task, status: 1, user: @user)
      create(:task, status: 2, user: @user)

      visit tasks_path
      expect(find("tbody")).to have_content(I18n.t("task.status_option")[0]).and have_content(I18n.t("task.status_option")[1]).and have_content(I18n.t("task.status_option")[2])

      select I18n.t("task.status_option")[2], from: "q_status_eq"
      click_button(I18n.t(:search))
      #完成
      expect(find("tbody")).to have_content(I18n.t("task.status_option")[2])
      #待處理 #進行中
      expect(find("tbody")).to have_no_content(I18n.t("task.status_option")[0]).or have_no_content(I18n.t("task.status_option")[1])
    end
  end
end
