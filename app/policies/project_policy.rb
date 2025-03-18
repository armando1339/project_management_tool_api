class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.present?
  end

  def create?
    user&.admin? || user&.project_manager?
  end

  def update?
    user&.admin? || user&.project_manager?
  end

  def destroy?
    user&.admin?
  end
end