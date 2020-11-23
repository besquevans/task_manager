require "rails_helper"

RSpec.feature "Read task", type: :feature, driver: :chrome, js: true, slow: true  do
  let(:default_email){ "test@mail.com" }
  let(:password){ "123456" }
  let(:test_task_title){ "Test Task" }

  before do
    create(:user)
    visit sign_in_users_path
    fill_in :user_email,  with: default_email
    fill_in :user_password,  with: password
    click_button(I18n.t("user.login"))
  end

  describe "#index" do
    context "create 2 tasks" do
      before do
        create(:task, title: "task1")
        create(:task, title: "task2")

        other = create(:user, email: "other@mail.com")
        other_task = create(:task, user: other, title: "Other Task")
        visit tasks_path
      end

      it "has 2 tasks" do
        expect(page).to have_content("task1")
        expect(page).to have_content("task2")
      end

      it "has only self tasks" do
        expect(page).to have_no_content("Other Task")
      end
    end
  end

  describe "#show" do
    context "at selected task show" do
      before do
        task = create(:task)
        selected_task = create(:task, title: "Selected Task")
        task = create(:task)
        visit task_path(selected_task.id)
      end

      it "has selected task" do
        expect(page).to have_content("Selected Task")
      end
    end
  end

  describe "#create" do
    context "create new task" do
      let(:new_task_title){ "New Task" }

      before do
        visit new_task_path
        fill_in :task_title,  with: new_task_title
        fill_in :task_content,  with: "New Task Content"
        fill_in :task_start_at,  with: Time.now
        fill_in :task_end_at,  with: Time.now + 1.day
        #低
        select(I18n.t("task.priority_option")[0], from: "form-priority")
        #進行中
        select(I18n.t("task.status_option")[1], from: "form-status")
        #送出
        click_button(I18n.t(:send))
      end

      it "should create success" do
        #notice 新增任務成功！
        expect(page).to have_content(I18n.t("task.create_success"))
      end

      it "should has new title" do
        expect(page).to have_content(new_task_title)
      end

      it "should has new priority" do
        expect(page).to have_content(I18n.t("task.priority_option")[0])
      end

      it "should has new status" do
        expect(page).to have_content(I18n.t("task.status_option")[1])
      end
    end
  end

  describe "#update" do
    context "update 1 task" do
      let(:renew_task_title){ "Renew Task Title" }

      before do
        task = create(:task)
        visit edit_task_path(task)
        fill_in :task_title,  with: renew_task_title
        fill_in :task_content,  with: "Renew Task Content"
        fill_in :task_start_at,  with: Time.now
        fill_in :task_end_at,  with: Time.now + 1.day
        #高
        select(I18n.t("task.priority_option")[2], from: "form-priority")
        #完成
        select(I18n.t("task.status_option")[2], from: "form-status")
        #送出
        click_button(I18n.t(:send))
      end

      it "update task" do
        #notice 更新任務成功！
        expect(page).to have_content(I18n.t("task.update_success"))
      end

      it "should has updated title" do
        expect(page).to have_content(renew_task_title)
      end

      it "should has updated priority" do
        expect(page).to have_content(I18n.t("task.priority_option")[2])
      end

      it "should has updated status" do
        expect(page).to have_content(I18n.t("task.status_option")[2])
      end
    end
  end

  describe "#destroy" do
    context "destory 1 task" do
      before do
        task = create(:task)
        selected_task = create :task, title: "Selected Task"
        task = create(:task)
        visit tasks_path
        find("tr", text: "Selected Task").click_link("Destroy")
        page.driver.browser.switch_to.alert.accept #確認刪除
      end

      it "should destroy success" do
        #notice 刪除任務成功！
        expect(page).to have_content(I18n.t("task.delete_success"))
      end

      it "keep other tasks" do
        expect(page).to have_content("Test Task", count: 2)
      end

      it "remove selected task" do
        expect(page).to have_no_content("Selected Task")
      end
    end
  end
end
