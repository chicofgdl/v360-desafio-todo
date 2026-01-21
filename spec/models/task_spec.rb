require 'rails_helper'

RSpec.describe Task, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { User.create!(email: "user@example.com", password: "password") }
  let(:list) { List.create!(title: "Main", user: user) }

  describe "validations" do
    it "is valid with a title and list" do
      task = described_class.new(title: "Task", list: list)

      expect(task).to be_valid
    end

    it "requires a title" do
      task = described_class.new(title: nil, list: list)

      expect(task).not_to be_valid
      expect(task.errors[:title]).to be_present
    end

    it "limits title length to 100 characters" do
      task = described_class.new(title: "a" * 101, list: list)

      expect(task).not_to be_valid
      expect(task.errors[:title]).to be_present
    end

    it "requires a list" do
      task = described_class.new(title: "Task", list: nil)

      expect(task).not_to be_valid
      expect(task.errors[:list]).to be_present
    end
  end

  describe "associations" do
    it "belongs to list" do
      association = described_class.reflect_on_association(:list)

      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "scopes" do
    it "returns favorited tasks" do
      favorite = described_class.create!(title: "Fav", list: list, favorite: true)
      described_class.create!(title: "Normal", list: list, favorite: false)

      expect(described_class.favorited).to contain_exactly(favorite)
    end

    it "returns tasks due today" do
      travel_to(Time.zone.local(2026, 1, 20, 10, 0, 0)) do
        today_task = described_class.create!(title: "Today", list: list, due_at: Time.zone.now.change(hour: 14))
        described_class.create!(title: "Tomorrow", list: list, due_at: Time.zone.now + 1.day)

        expect(described_class.due_today).to contain_exactly(today_task)
      end
    end

    it "returns tasks due soon" do
      travel_to(Time.zone.local(2026, 1, 20, 10, 0, 0)) do
        tomorrow = described_class.create!(title: "Tomorrow", list: list, due_at: Time.zone.now + 1.day)
        week_out = described_class.create!(title: "Week", list: list, due_at: Time.zone.now + 7.days)
        described_class.create!(title: "Today", list: list, due_at: Time.zone.now)
        described_class.create!(title: "Later", list: list, due_at: Time.zone.now + 8.days)

        expect(described_class.due_soon).to contain_exactly(tomorrow, week_out)
      end
    end

    it "returns overdue tasks that are not done" do
      travel_to(Time.zone.local(2026, 1, 20, 10, 0, 0)) do
        overdue = described_class.create!(title: "Overdue", list: list, due_at: Time.zone.now - 1.hour, done: false)
        described_class.create!(title: "Done", list: list, due_at: Time.zone.now - 2.hours, done: true)
        described_class.create!(title: "Future", list: list, due_at: Time.zone.now + 1.hour, done: false)

        expect(described_class.overdue).to contain_exactly(overdue)
      end
    end
  end
end
