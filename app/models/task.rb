class Task < ApplicationRecord
  validates :title, presence: true
  validates :start_at, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  belongs_to :user, counter_cache: true

  acts_as_taggable_on :tags
end
