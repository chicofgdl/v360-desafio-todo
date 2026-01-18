class List < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  acts_as_list scope: :user

  validates :title, presence: true, length: { maximum: 40 }
end
