class List < ApplicationRecord
  belongs_to :user
  has_many :tasks, -> { order(:position) }, dependent: :destroy

  acts_as_list scope: :user

  validates :title,
    presence: true,
    length: { maximum: 40 },
    uniqueness: { scope: :user_id, case_sensitive: false }
end
