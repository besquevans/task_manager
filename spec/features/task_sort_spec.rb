require "rails_helper"

RSpec.feature "Sort tasks", type: :feature, driver: :chrome, js: true, slow: true do
  context "default" do
    it "sort by created_at" do
      (1..5).each do |i|
        create(:task, title: "Task #{i}")
      end
      visit tasks_path

      task_names = page.all("td.task-title").map(&:text)
      expect(task_names).to eq(["Task 5", "Task 4", "Task 3", "Task 2", "Task 1"])
    end
  end

  context "click end_at" do
    it "sort by end_at" do
      create(:task, title: "Task 1", end_at: Time.zone.now)
      create(:task, title: "Task 2", end_at: Time.zone.now + 2.day)
      create(:task, title: "Task 3", end_at: Time.zone.now + 1.day)
      visit tasks_path

      task_names = page.all("td.task-title").map(&:text)
      expect(task_names).to eq(["Task 3", "Task 2", "Task 1"])

      expect(page.find(".end_at a").text).to eq("結束時間")
      click_link("結束時間")
      expect(page).to have_content("Task 1")
      task_names = page.all("td.task-title").map(&:text)
      expect(task_names).to eq(["Task 1", "Task 3", "Task 2"])
    end
  end
end
