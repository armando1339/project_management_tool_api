require 'rails_helper'

RSpec.describe Api::V1::GithubController, type: :request do
  let(:admin) { create(:user, role: :admin) }
  let(:developer) { create(:user, role: :developer) }
  let(:project_manager) { create(:user, role: :project_manager) }
  let(:guest) { nil }

  describe "GET /api/v1/github/latest_public_repositories", :vcr do
    context "when the user is authenticated" do
      it "allows access for admin with pagination" do
        VCR.use_cassette("github_latest_repos_page_1") do
          get latest_public_repositories_api_v1_github_index_path, params: { page: 1, per_page: 2 }, headers: auth_headers(admin)

          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response.length).to eq(2)
        end
      end

      it "allows access for project managers with pagination" do
        VCR.use_cassette("github_latest_repos_page_2") do
          get latest_public_repositories_api_v1_github_index_path, params: { page: 2, per_page: 2 }, headers: auth_headers(project_manager)

          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response.length).to eq(2)
        end
      end

      it "allows access for developers with pagination" do
        VCR.use_cassette("github_latest_repos_page_1") do
          get latest_public_repositories_api_v1_github_index_path, params: { page: 1, per_page: 2 }, headers: auth_headers(developer)

          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response.length).to eq(2)
        end
      end
    end

    context "when the user is not authenticated" do
      it "denies access" do
        get latest_public_repositories_api_v1_github_index_path

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
