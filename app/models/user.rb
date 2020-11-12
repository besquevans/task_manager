class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  has_secure_password

  has_many :tasks, dependent: :destroy
end
