require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with email and password" do
      user = described_class.new(email: "user@example.com", password: "password")

      expect(user).to be_valid
    end

    it "requires an email" do
      user = described_class.new(email: nil, password: "password")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "requires a password" do
      user = described_class.new(email: "user@example.com", password: nil)

      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end
  end

  describe "associations" do
    it "has many lists" do
      association = described_class.reflect_on_association(:lists)

      expect(association.macro).to eq(:has_many)
    end

    it "destroys lists when destroyed" do
      user = described_class.create!(email: "user@example.com", password: "password")
      List.create!(title: "Home", user: user)

      expect { user.destroy }.to change(List, :count).by(-1)
    end
  end
end
