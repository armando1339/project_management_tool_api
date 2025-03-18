class User < ApplicationRecord
  has_secure_password

  enum :role, admin: 0, project_manager: 1, developer: 2

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password
end