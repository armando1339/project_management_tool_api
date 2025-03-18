Doorkeeper::Application.create!(
  name: "Project Management Frontend",
  redirect_uri: "http://example.com",
  scopes: "",
  confidential: true
)

admin = User.create(
  email: "admin@example.com",
  password: "Password",
  password_confirmation: "Password",
  role: :admin
)

pm = User.create(
  email: "pm@example.com",
  password: "Password",
  password_confirmation: "Password",
  role: :project_manager
)

dev = User.create(
  email: "dev@example.com",
  password: "Password",
  password_confirmation: "Password",
  role: :developer
)

project1 = Project.create(
  name: "API Development",
  description: "Project for developing a REST API"
)

project2 = Project.create(
  name: "Frontend Refactor",
  description: "Refactoring the frontend codebase"
)

Task.create(
  title: "Setup Rails API",
  description: "Initialize the Rails API only project",
  status: :to_do,
  project: project1
)

Task.create(
  title: "Implement Authentication",
  description: "Use Doorkeeper for OAuth2 authentication",
  status: :in_progress,
  project: project1
)

Task.create(
  title: "Redesign UI",
  description: "Improve the user interface for better UX",
  status: :done,
  project: project2
)
