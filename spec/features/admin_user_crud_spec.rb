require "rails_helper"

RSpec.feature "Admin User CRUD", type: :feature, driver: :chrome, js: true, slow: true  do
  let(:admin_email){ "root@mail.com" }
  let(:default_email){ "test@mail.com" }
  let(:password){ "123456" }

  before do
    admin = create(:admin)
    visit sign_in_users_path
    fill_in :user_email,	with: admin_email
    fill_in :user_password,	with: password
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

    it "tasks count 0 at begining" do
      user = create(:user)
      visit admin_users_path
      expect(find("tr", text: default_email)).to have_content("0")
    end

    it "show tasks count 2" do
      user = create(:user)
      create(:task, user: user)
      create(:task, user: user)
      visit admin_users_path
      expect(find("tr", text: default_email)).to have_content("2")
    end
  end

  context "show" do
    before do
      create(:task, title: "task1")
      create(:task, title: "task2")
      visit admin_users_path
      find("tr", text: :admin).click_link("Show")
    end

    it "show user all tasks" do
      expect(page).to have_content("task1")
      expect(page).to have_content("task2")
    end
  end

  context "new and create" do
    let(:new_user_email){ "new_user@mail.com" }

    before do
      visit admin_users_path
      click_link(I18n.t("user.new_user"))
    end

    it "create 1 user" do
      fill_in :user_email,	with: new_user_email
      fill_in :user_password,	with: password
      fill_in :user_password_confirmation,	with: password
      click_button(I18n.t(:send))

      expect(page).to have_content(I18n.t("user.create_success"))
      expect(page).to have_content(new_user_email)
    end

    it "create 1 admin" do
      fill_in :user_email,	with: new_user_email
      fill_in :user_password,	with: password
      fill_in :user_password_confirmation,	with: password
      select(I18n.t("user.role_option")[:admin], from: "user[role]")
      click_button(I18n.t(:send))

      expect(page).to have_content(I18n.t("user.create_success"))
      expect(find("tr", text: new_user_email)).to have_content("admin")
    end
  end

  context "edit and update" do
    before do
      create(:user)
      visit admin_users_path
      find("tr", text: default_email).click_link("Edit")
    end

    it "update email" do
      new_mail = "new_mail@mail.com"
      fill_in :user_email,	with: new_mail
      fill_in :user_password,	with: password
      fill_in :user_password_confirmation,	with: password
      click_button(I18n.t(:send))

      expect(page).to have_content(I18n.t("user.update_success"))
      expect(page).to have_content(new_mail)
    end

    it "update role" do
      fill_in :user_password,	with: password
      fill_in :user_password_confirmation,	with: password
      select(I18n.t("user.role_option")[:admin], from: "user[role]")
      click_button(I18n.t(:send))

      expect(page).to have_content(I18n.t("user.update_success"))
      expect(find("tr", text: default_email)).to have_content("admin")
    end
  end

  context "destroy" do
    it "destroy 1 user" do
      selected_user = "selected_user@mail.com"
      create(:user, email: selected_user)
      create(:user)

      visit admin_users_path
      expect(page).to have_content(default_email)
      expect(page).to have_content(selected_user)
      find("tr", text: selected_user).click_link("Destroy")
      page.driver.browser.switch_to.alert.accept #確認刪除
      expect(page).to have_content(I18n.t("user.delete_success"))
      expect(page).to have_content(default_email)
      expect(page).to have_no_content(selected_user)
    end
  end
end
