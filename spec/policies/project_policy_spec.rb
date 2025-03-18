require 'rails_helper'

RSpec.describe ProjectPolicy, type: :policy do
  subject { described_class }

  let(:admin) { create(:user, role: :admin) }
  let(:project_manager) { create(:user, role: :project_manager) }
  let(:developer) { create(:user, role: :developer) }
  let(:guest) { nil }
  let(:project) { create(:project) }

  permissions :index? do
    it "grants access to any user" do
      expect(subject).to permit(admin, project)
      expect(subject).to permit(project_manager, project)
      expect(subject).to permit(developer, project)
      expect(subject).to permit(guest, project)
    end
  end

  permissions :show? do
    it "grants access to authenticated users" do
      expect(subject).to permit(admin, project)
      expect(subject).to permit(project_manager, project)
      expect(subject).to permit(developer, project)
    end

    it "denies access to guests" do
      expect(subject).not_to permit(guest, project)
    end
  end

  permissions :create? do
    it "allows admin and project managers to create projects" do
      expect(subject).to permit(admin, project)
      expect(subject).to permit(project_manager, project)
    end

    it "denies access to developers and guests" do
      expect(subject).not_to permit(developer, project)
      expect(subject).not_to permit(guest, project)
    end
  end

  permissions :update? do
    it "allows admin and project managers to update projects" do
      expect(subject).to permit(admin, project)
      expect(subject).to permit(project_manager, project)
    end

    it "denies access to developers and guests" do
      expect(subject).not_to permit(developer, project)
      expect(subject).not_to permit(guest, project)
    end
  end

  permissions :destroy? do
    it "allows only admins to destroy projects" do
      expect(subject).to permit(admin, project)
    end

    it "denies access to project managers, developers, and guests" do
      expect(subject).not_to permit(project_manager, project)
      expect(subject).not_to permit(developer, project)
      expect(subject).not_to permit(guest, project)
    end
  end
end
