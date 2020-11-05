require "rails_helper"

RSpec.feature "Sort tasks", type: :feature, js: true, slow: true do
  context "default" do
    it "sort by created_at" do
      (1..5).each do |i|
        create(:task, title: "Task #{i}")
      end
      visit tasks_path
      expect(page.all("tbody tr").to_a.map{|tr| tr.all("td").first.text}).to eq((1..5).map{|i| "Task #{i}"}.reverse)
      # expect(page.all("tbody tr")[4]).to have_content("Task 1")
      # expect(page.all("tbody tr")[3]).to have_content("Task 2")
      # expect(page.all("tbody tr")[2]).to have_content("Task 3")
      # expect(page.all("tbody tr")[1]).to have_content("Task 4")
      # expect(page.all("tbody tr")[0]).to have_content("Task 5")
    end
  end

  context "click end_at" do
    it "sort by end_at" do

      create(:task, title: "Task 1", end_at: Time.zone.now)
      create(:task, title: "Task 2", end_at: Time.zone.now + 2.day)
      create(:task, title: "Task 3", end_at: Time.zone.now + 1.day)
      visit tasks_path
      expect(page.all("tbody tr").to_a.map{|tr| tr.all("td").first.text}).to eq((1..3).map{|i| "Task #{i}"}.reverse)
      click_button("結束時間")
      # wait_for_ajax
      expect(page.all("tbody tr")[0]).to have_content("Task 1")
      expect(page.all("tbody tr")[1]).to have_content("Task 3")
      expect(page.all("tbody tr")[2]).to have_content("Task 2")
    end
  end
end
