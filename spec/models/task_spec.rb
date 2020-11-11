require 'rails_helper'

RSpec.describe Task, type: :model do
  before(:each) do
    @user = create(:user)
  end

  context "validate" do
    it "title" do
      task = Task.new(title: nil, user: @user)
      expect(task).to_not be_valid
      task = create(:task, title: "New Task")
      expect(task).to be_valid
    end

    it "start_at" do
      task = Task.new(start_at: nil, user: @user)
      expect(task).to_not be_valid
      task = create(:task, start_at: Time.zone.now)
      expect(task).to be_valid
    end

    it "priority" do
      task = Task.new(priority: nil, user: @user)
      expect(task).to_not be_valid
      task = create(:task, priority: 1)
      expect(task).to be_valid
    end

    it "status" do
      task = Task.new(status: nil, user: @user)
      expect(task).to_not be_valid
      task = create(:task, status: 1)
      expect(task).to be_valid
    end
  end
end
