module Api
  module V1
    class GithubController < ApplicationController
      before_action -> { authorize :github }

      def latest_public_repositories
        page = params[:page] || 1
        per_page = params[:per_page] || 30

        github_service = GithubService.new
        repositories = github_service.fetch_latest_public_repositories(page: page.to_i, per_page: per_page.to_i)

        if repositories.any?
          render json: repositories
        else
          render json: { error: "Could not fetch latest repositories" }, status: :bad_request
        end
      end
    end
  end
end
