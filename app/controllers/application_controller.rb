class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :doorkeeper_authorize!
  before_action :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token&.resource_owner_id)
  end

  def user_not_authorized
    render json: { error: "Unauthorized" }, status: :forbidden
  end
end
