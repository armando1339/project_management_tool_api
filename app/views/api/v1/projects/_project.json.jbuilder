json.extract! project, :id, :name, :description, :created_at, :updated_at
json.tasks project.tasks, partial: 'api/v1/tasks/task', as: :task