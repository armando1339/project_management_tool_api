require 'rails_helper'

RSpec.describe TaskPolicy, type: :policy do
  subject { described_class }

  let(:admin) { create(:user, role: :admin) }
  let(:project_manager) { create(:user, role: :project_manager) }
  let(:developer) { create(:user, role: :developer) }
  let(:guest) { nil }
  let(:project) { create(:project) }
  let(:task) { create(:task, project: project) }

  permissions :index? do
    it "grants access to authenticated users" do
      expect(subject).to permit(admin, task)
      expect(subject).to permit(project_manager, task)
      expect(subject).to permit(developer, task)
    end

    it "denies access to guests" do
      expect(subject).not_to permit(guest, task)
    end
  end

  permissions :show? do
    it "grants access to authenticated users" do
      expect(subject).to permit(admin, task)
      expect(subject).to permit(project_manager, task)
      expect(subject).to permit(developer, task)
    end

    it "denies access to guests" do
      expect(subject).not_to permit(guest, task)
    end
  end

  permissions :create? do
    it "allows admin, project managers, and developers to create tasks" do
      expect(subject).to permit(admin, task)
      expect(subject).to permit(project_manager, task)
      expect(subject).to permit(developer, task)
    end

    it "denies access to guests" do
      expect(subject).not_to permit(guest, task)
    end
  end

  permissions :update? do
    it "allows admin, project managers, and developers to update tasks" do
      expect(subject).to permit(admin, task)
      expect(subject).to permit(project_manager, task)
      expect(subject).to permit(developer, task)
    end

    it "denies access to guests" do
      expect(subject).not_to permit(guest, task)
    end
  end

  permissions :destroy? do
    it "allows only admins and project managers to delete tasks" do
      expect(subject).to permit(admin, task)
      expect(subject).to permit(project_manager, task)
    end

    it "denies access to developers and guests" do
      expect(subject).not_to permit(developer, task)
      expect(subject).not_to permit(guest, task)
    end
  end

  permissions :assign? do
    it "allows admins to assign users" do
      expect(subject).to permit(admin, task)
    end

    it "allows project managers to assign users" do
      expect(subject).to permit(project_manager, task)
    end

    it "allows developers to assign users" do
      expect(subject).to permit(developer, task)
    end

    it "denies access to unauthenticated users" do
      expect(subject).not_to permit(guest, task)
    end
  end
end
