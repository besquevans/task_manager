class Task < ApplicationRecord
  validates :title, presence: true
  validates :start_at, presence: true
  validates :priority, presence: true
  validates :status, presence: true
end
