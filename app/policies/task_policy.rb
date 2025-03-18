class TaskPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user&.admin? || user&.project_manager? || user&.developer?
  end

  def update?
    user&.admin? || user&.project_manager? || user&.developer?
  end

  def destroy?
    user&.admin? || user&.project_manager?
  end
end
