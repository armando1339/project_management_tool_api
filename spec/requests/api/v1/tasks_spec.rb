require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:project_manager) { create(:user, :project_manager) }
  let(:developer) { create(:user, :developer) }
  let(:project) { create(:project) }
  let(:task) { create(:task, project: project) }
  let(:user_to_assign) { create(:user, role: :developer) }

  describe "GET /api/v1/projects/:project_id/tasks" do
    it "returns a successful response for authenticated users" do
      get api_v1_project_tasks_path(project), headers: auth_headers(admin)
      expect(response).to have_http_status(:ok)
    end

    it "denies access for guests" do
      get api_v1_project_tasks_path(project)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/projects/:project_id/tasks/:id" do
    context "when the user is authenticated" do
      it "allows access" do
        get api_v1_project_task_path(project, task), headers: auth_headers(admin)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user is not authenticated" do
      it "denies access" do
        get api_v1_project_task_path(project, task)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/projects/:project_id/tasks" do
    let(:valid_params) { { task: { title: "New Task", description: "Task Description", status: "to_do" } } }

    context "when the user is an admin, project manager, or developer" do
      it "creates a task as admin" do
        post api_v1_project_tasks_path(project), params: valid_params, headers: auth_headers(admin)
        expect(response).to have_http_status(:created)
      end

      it "creates a task as project manager" do
        post api_v1_project_tasks_path(project), params: valid_params, headers: auth_headers(project_manager)
        expect(response).to have_http_status(:created)
      end

      it "creates a task as developer" do
        post api_v1_project_tasks_path(project), params: valid_params, headers: auth_headers(developer)
        expect(response).to have_http_status(:created)
      end
    end

    context "when the user is a guest" do
      it "denies access" do
        post api_v1_project_tasks_path(project), params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /api/v1/projects/:project_id/tasks/:id" do
    let(:update_params) { { task: { title: "Updated Task" } } }

    context "when the user is an admin, project manager, or developer" do
      it "updates the task as admin" do
        patch api_v1_project_task_path(project, task), params: update_params, headers: auth_headers(admin)
        expect(response).to have_http_status(:ok)
      end

      it "updates the task as project manager" do
        patch api_v1_project_task_path(project, task), params: update_params, headers: auth_headers(project_manager)
        expect(response).to have_http_status(:ok)
      end

      it "updates the task as developer" do
        patch api_v1_project_task_path(project, task), params: update_params, headers: auth_headers(developer)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user is a guest" do
      it "denies access" do
        patch api_v1_project_task_path(project, task), params: update_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/projects/:project_id/tasks/:id" do
    context "when the user is an admin or project manager" do
      it "deletes the task as admin" do
        delete api_v1_project_task_path(project, task), headers: auth_headers(admin)
        expect(response).to have_http_status(:no_content)
      end

      it "deletes the task as project manager" do
        delete api_v1_project_task_path(project, task), headers: auth_headers(project_manager)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the user is a developer or guest" do
      it "denies access for developer" do
        delete api_v1_project_task_path(project, task), headers: auth_headers(developer)
        expect(response).to have_http_status(:forbidden)
      end

      it "denies access for guest" do
        delete api_v1_project_task_path(project, task)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/projects/:project_id/tasks/:id/assign_user" do
    context "when the user is an admin, project manager, or developer" do
      it "assigns a user as admin" do
        post assign_user_api_v1_project_task_path(project, task),
             params: { user_id: user_to_assign.id },
             headers: auth_headers(admin)

        expect(response).to have_http_status(:ok)
        expect(task.reload.assigned_user).to eq(user_to_assign)
      end

      it "assigns a user as project manager" do
        post assign_user_api_v1_project_task_path(project, task),
             params: { user_id: user_to_assign.id },
             headers: auth_headers(project_manager)

        expect(response).to have_http_status(:ok)
        expect(task.reload.assigned_user).to eq(user_to_assign)
      end

      it "assigns a user as developer" do
        post assign_user_api_v1_project_task_path(project, task),
             params: { user_id: user_to_assign.id },
             headers: auth_headers(developer)

        expect(response).to have_http_status(:ok)
        expect(task.reload.assigned_user).to eq(user_to_assign)
      end
    end

    context "when the user is a guest" do
      it "denies access" do
        post assign_user_api_v1_project_task_path(project, task),
             params: { user_id: user_to_assign.id }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/projects/:project_id/tasks/:id/unassign_user" do
    before { task.update(assigned_user: user_to_assign) }

    context "when the user is an admin, project manager, or developer" do
      it "removes the assigned user as admin" do
        delete unassign_user_api_v1_project_task_path(project, task),
               headers: auth_headers(admin)

        expect(response).to have_http_status(:ok)
        expect(task.reload.assigned_user).to be_nil
      end

      it "removes the assigned user as project manager" do
        delete unassign_user_api_v1_project_task_path(project, task),
               headers: auth_headers(project_manager)

        expect(response).to have_http_status(:ok)
        expect(task.reload.assigned_user).to be_nil
      end

      it "removes the assigned user as developer" do
        delete unassign_user_api_v1_project_task_path(project, task),
               headers: auth_headers(developer)

        expect(response).to have_http_status(:ok)
        expect(task.reload.assigned_user).to be_nil
      end
    end

    context "when the user is a guest" do
      it "denies access" do
        delete unassign_user_api_v1_project_task_path(project, task)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
