class Task < ApplicationRecord
  belongs_to :list

  acts_as_list scope: :list

  validates :title, presence: true, length: { maximum: 100 }

  scope :done, -> { where(done: true) }
  scope :pending, -> { where(done: false) }
  scope :incomplete, -> { where(done: false) }
  scope :favorited, -> { where(favorite: true) }
  scope :due_today, -> {
    where(due_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  }
  scope :due_soon, -> {
    where(due_at: Time.zone.tomorrow.beginning_of_day..(Time.zone.today + 7.days).end_of_day)
  }
  scope :overdue, -> {
    where("due_at < ?", Time.zone.now).where(done: false)
  }
  scope :search_title, ->(query) {
    return all if query.blank?
    where("title LIKE ?", "%#{sanitize_sql_like(query)}%")}
end
