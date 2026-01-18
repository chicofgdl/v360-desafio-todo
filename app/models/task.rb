class Task < ApplicationRecord
  belongs_to :list

  act_as_list scope: :list

  validates: :title, presence: true, length: { maximum: 100 }
end
