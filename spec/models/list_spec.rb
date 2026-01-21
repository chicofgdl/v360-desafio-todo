require 'rails_helper'

RSpec.describe List, type: :model do
  let(:user) { User.create!(email: "user@example.com", password: "password") }

  describe "validations" do
    it "é válido com um título e usuário" do
      list = described_class.new(title: "Work", user: user)

      expect(list).to be_valid
    end

    it "requer um título" do
      list = described_class.new(title: nil, user: user)

      expect(list).not_to be_valid
      expect(list.errors[:title]).to be_present
    end

    it "limita o tamanho do título a 40 caracteres" do
      list = described_class.new(title: "a" * 41, user: user)

      expect(list).not_to be_valid
      expect(list.errors[:title]).to be_present
    end
  end

  describe "associations" do
    it "pertence a usuário" do
      association = described_class.reflect_on_association(:user)

      expect(association.macro).to eq(:belongs_to)
    end

    it "tem muitas tarefas" do
      association = described_class.reflect_on_association(:tasks)

      expect(association.macro).to eq(:has_many)
    end

    it "remove as tarefas quando destruída" do
      list = described_class.create!(title: "Home", user: user)
      Task.create!(title: "Task", list: list)

      expect { list.destroy }.to change(Task, :count).by(-1)
    end
  end
end
