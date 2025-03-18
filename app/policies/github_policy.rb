class GithubPolicy < ApplicationPolicy
  def latest_public_repositories?
    user.present?
  end
end