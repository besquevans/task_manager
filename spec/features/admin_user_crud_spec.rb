require "rails_helper"

RSpec.feature "Admin User CRUD", type: :feature, driver: :chrome, js: true, slow: true  do
  before(:each) do
    @admin = "root@mail.com"
    role = "admin"
    @password = "123456"
    user = create(:user, email: @admin, role: role)
    visit sign_in_users_path
    fill_in :user_email,	with: @admin
    fill_in :user_password,	with: @password
    click_button(I18n.t("user.login"))
  end

  context "index" do
    it "find 2 users" do
      create(:user, email: "test1@mail.com")
      create(:user, email: "test2@mail.com")

      visit admin_users_path
      expect(page).to have_content("test1@mail.com")
      expect(page).to have_content("test2@mail.com")
    end

    it "find user tasks count" do
      user = create(:user)
      visit admin_users_path
      expect(find("tr", text: "test@mail.com")).to have_content("0")

      create(:task, user: user)
      create(:task, user: user)
      visit admin_users_path
      expect(find("tr", text: "test@mail.com")).to have_content("2")
    end
  end

  context "new and create" do
    it "create 1 user" do
      visit new_admin_user_path
      email = "new_user@mail.com"
      fill_in :user_email,	with: email
      fill_in :user_password,	with: @password
      fill_in :user_password_confirmation,	with: @password
      click_button(I18n.t(:send))

      expect(page).to have_content(I18n.t("user.create_success"))
      expect(page).to have_content(email)
    end

    it "create 1 admin" do
      visit new_admin_user_path
      email = "new_user@mail.com"
      fill_in :user_email,	with: email
      fill_in :user_password,	with: @password
      fill_in :user_password_confirmation,	with: @password
      select(I18n.t("user.role_option")[:admin], from: "user[role]")
      click_button(I18n.t(:send))

      expect(page).to have_content(I18n.t("user.create_success"))
      expect(page).to have_content("admin", count: 2)
    end
  end

  context "show" do
    it "find user all tasks" do
      create(:task, title: "task1")
      create(:task, title: "task2")
      visit admin_users_path
      find("tr", text: @admin).click_link("Show")
      expect(page).to have_content("task1")
      expect(page).to have_content("task2")
    end
  end

  context "edit and update" do
    it "update email" do
      create(:user)
      visit admin_users_path
      new_mail = "new_mail@mail.com"
      find("tr", text: "test@mail.com").click_link("Edit")
      fill_in :user_email,	with: new_mail
      fill_in :user_password,	with: @password
      fill_in :user_password_confirmation,	with: @password
      click_button(I18n.t(:send))

      expect(page).to have_content(I18n.t("user.update_success"))
      expect(page).to have_content(new_mail)
    end

    it "update role" do
      create(:user)
      visit admin_users_path
      expect(page).to have_content("admin", count: 1)
      find("tr", text: "test@mail.com").click_link("Edit")
      fill_in :user_password,	with: @password
      fill_in :user_password_confirmation,	with: @password
      select(I18n.t("user.role_option")[:admin], from: "user[role]")
      click_button(I18n.t(:send))

      expect(page).to have_content(I18n.t("user.update_success"))
      expect(page).to have_content("admin", count: 2)
    end
  end

  context "destroy" do
    it "destroy 1 user" do
      selected_user = "selected_user@mail.com"
      create(:user, email: selected_user)
      create(:user)

      visit admin_users_path
      expect(page).to have_content("test@mail.com")
      expect(page).to have_content(selected_user)
      find("tr", text: selected_user).click_link("Destroy")
      page.driver.browser.switch_to.alert.accept #確認刪除
      expect(page).to have_content(I18n.t("user.delete_success"))
      expect(page).to have_content("test@mail.com")
      expect(page).to have_no_content(selected_user)
    end
  end
end
