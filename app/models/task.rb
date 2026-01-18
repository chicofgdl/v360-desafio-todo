class Task < ApplicationRecord
  belongs_to :list

  act_as_list scope: :list

  validates: :title, presence: true, length: { maximum: 100 }

  scope :done, -> { where(done: true)}
  scope :pending, -> { where(done: false)}
  scope :search_title, ->(query) { 
    return all if query.blank?
    where("title LIKE ?", "%#{sanitize_sql_like(query)}%")}
end
