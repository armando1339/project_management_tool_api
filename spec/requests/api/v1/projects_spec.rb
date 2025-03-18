require 'rails_helper'

RSpec.describe "Projects API", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:project_manager) { create(:user, :project_manager) }
  let(:developer) { create(:user, :developer) }
  let(:guest) { nil }
  let(:project) { create(:project) }

  describe "GET /api/v1/projects" do
    it "returns a successful response for any user" do
      get api_v1_projects_path, headers: auth_headers(admin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/projects/:id" do
    context "when the user is authenticated" do
      it "allows access" do
        get api_v1_project_path(project), headers: auth_headers(admin)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user is not authenticated" do
      it "denies access" do
        get api_v1_project_path(project)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/projects" do
    let(:valid_params) { { project: { name: "New Project", description: "Project Description" } } }

    context "when the user is an admin or project manager" do
      it "creates a project as admin" do
        post api_v1_projects_path, params: valid_params, headers: auth_headers(admin)
        expect(response).to have_http_status(:created)
      end

      it "creates a project as project manager" do
        post api_v1_projects_path, params: valid_params, headers: auth_headers(project_manager)
        expect(response).to have_http_status(:created)
      end
    end

    context "when the user is a developer or guest" do
      it "denies access for developer" do
        post api_v1_projects_path, params: valid_params, headers: auth_headers(developer)
        expect(response).to have_http_status(:forbidden)
      end

      it "denies access for guest" do
        post api_v1_projects_path, params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /api/v1/projects/:id" do
    let(:update_params) { { project: { name: "Updated Project" } } }

    context "when the user is an admin or project manager" do
      it "updates the project as admin" do
        patch api_v1_project_path(project), params: update_params, headers: auth_headers(admin)
        expect(response).to have_http_status(:ok)
      end

      it "updates the project as project manager" do
        patch api_v1_project_path(project), params: update_params, headers: auth_headers(project_manager)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user is a developer or guest" do
      it "denies access for developer" do
        patch api_v1_project_path(project), params: update_params, headers: auth_headers(developer)
        expect(response).to have_http_status(:forbidden)
      end

      it "denies access for guest" do
        patch api_v1_project_path(project), params: update_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/projects/:id" do
    context "when the user is an admin" do
      it "deletes the project" do
        delete api_v1_project_path(project), headers: auth_headers(admin)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the user is a project manager, developer, or guest" do
      it "denies access for project manager" do
        delete api_v1_project_path(project), headers: auth_headers(project_manager)
        expect(response).to have_http_status(:forbidden)
      end

      it "denies access for developer" do
        delete api_v1_project_path(project), headers: auth_headers(developer)
        expect(response).to have_http_status(:forbidden)
      end

      it "denies access for guest" do
        delete api_v1_project_path(project)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
