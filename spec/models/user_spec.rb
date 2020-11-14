require 'rails_helper'

RSpec.describe User, type: :model do
  context "validate" do
    it "email" do
      user = User.new(email: nil)
      expect(user).to_not be_valid
      user = create(:user, email: "New_User@mail.com")
      expect(user).to be_valid
    end

    it "password" do
      user = User.new(password: nil)
      expect(user).to_not be_valid
      user = create(:user, password: "123456")
      expect(user).to be_valid
    end
  end
end
