require "rails_helper"

RSpec.feature "Admin User CRUD", type: :feature, driver: :chrome, js: true, slow: true  do
  before(:each) do
    email = "root@mail.com"
    role = "admin"
    @password = "123456"
    user = create(:user, email: email, role: role)
    visit sign_in_users_path
    fill_in :user_email,	with: email
    fill_in :user_password,	with: @password
    click_button(I18n.t("user.login"))
  end

  context "index" do
    it "saw 2 users" do
      create(:user, email: "test1@mail.com")
      create(:user, email: "test2@mail.com")

      visit admin_users_path
      expect(page).to have_content("test1@mail.com")
      expect(page).to have_content("test2@mail.com")
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
