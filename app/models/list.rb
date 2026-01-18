class List < ApplicationRecord
  belongs_to :user
  has_many:tasks, dependent: destroy

  act_as_list scope: :user

  validates :title, presence: true, length: { maximum: 40 }
end
