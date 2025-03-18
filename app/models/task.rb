class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assigned_user, class_name: "User", optional: true

  enum :status, to_do: 0, in_progress: 1, done: 2

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
end
