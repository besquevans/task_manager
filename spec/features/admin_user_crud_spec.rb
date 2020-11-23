require "rails_helper"

RSpec.feature "Admin User CRUD", type: :feature, driver: :chrome, js: true, slow: true  do
  let(:user){ create(:user) }
  let(:admin_email){ "root@mail.com" }
  let(:default_email){ "test@mail.com" }
  let(:new_user_email){ "new_user@mail.com" }
  let(:password){ "123456" }

  before do
    admin = create(:admin)
    visit sign_in_users_path
    fill_in :user_email,	with: admin_email
    fill_in :user_password,	with: password
    click_button(I18n.t("user.login"))
  end

  describe "#index" do
    context "at begining" do
      before do
        user
        visit admin_users_path
      end

      it "should has 0 tasks" do
        expect(find("tr", text: default_email)).to have_content("0")
      end
    end

    context "2 tasks at index" do
      it "find 2 users" do
        create(:user, email: "test1@mail.com")
        create(:user, email: "test2@mail.com")

        visit admin_users_path
        expect(page).to have_content("test1@mail.com")
        expect(page).to have_content("test2@mail.com")
      end

      it "show tasks count 2" do
        2.times { create(:task, user: user) }
        visit admin_users_path
        expect(find("tr", text: default_email)).to have_content("2")
      end
    end
  end

  describe "#show" do
    context "show owner tasks" do
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
  end

  describe "#create" do
    context "create 1 user" do
      before do
        visit new_admin_user_path
        fill_in :user_email,  with: new_user_email
        fill_in :user_password,  with: password
        fill_in :user_password_confirmation,  with: password
        click_button(I18n.t(:send))
      end

      it "create success" do
        expect(page).to have_content(I18n.t("user.create_success"))
      end

      it "should has new user with email" do
        expect(page).to have_content(new_user_email)
      end
    end

    context "create 1 admin" do
      before do
        visit new_admin_user_path
        fill_in :user_email,  with: new_user_email
        fill_in :user_password,  with: password
        fill_in :user_password_confirmation,  with: password
        select(I18n.t("user.role_option")[:admin], from: "user[role]")
        click_button(I18n.t(:send))
      end

      it "should has new admin with email" do
        expect(find("tr", text: new_user_email)).to have_content("admin")
      end
    end
  end

  describe "#update" do
    context "update user email" do
      let(:new_email){ "new_email@mail.com" }

      before do
        visit edit_admin_user_path(user)
        fill_in :user_email,	with: new_email
        fill_in :user_password,	with: password
        fill_in :user_password_confirmation,	with: password
        click_button(I18n.t(:send))
      end

      it "update succes" do
        expect(page).to have_content(I18n.t("user.update_success"))
      end

      it "should has new email" do
        expect(page).to have_content(new_email)
      end
    end

    context "update user role" do
      before do
        visit edit_admin_user_path(user)
        fill_in :user_password,	with: password
        fill_in :user_password_confirmation,	with: password
        select(I18n.t("user.role_option")[:admin], from: "user[role]")
        click_button(I18n.t(:send))
      end

      it "has new role" do
        expect(find("tr", text: default_email)).to have_content("admin")
      end
    end
  end

  describe "#destroy" do
    context "destroy 1 user" do
      let(:selected_user){ "selected_user@mail.com" }

      before do
        create(:user, email: selected_user)
        create(:user)
        visit admin_users_path
        find("tr", text: selected_user).click_link("Destroy")
        page.driver.browser.switch_to.alert.accept #確認刪除
      end

      it "destroy success" do
        expect(page).to have_content(I18n.t("user.delete_success"))
      end

      it "should keep other user" do
        expect(page).to have_content(default_email)
      end

      it "shold has no selected user" do
        expect(page).to have_no_content(selected_user)
      end
    end
  end
end
