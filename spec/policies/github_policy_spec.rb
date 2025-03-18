require 'rails_helper'

RSpec.describe GithubPolicy, type: :policy do
  subject { described_class }

  let(:admin) { create(:user, role: :admin) }
  let(:developer) { create(:user, role: :developer) }
  let(:project_manager) { create(:user, role: :project_manager) }
  let(:guest) { nil }

  permissions :latest_public_repositories? do
    it "allows access to authenticated users" do
      expect(subject).to permit(admin)
      expect(subject).to permit(developer)
      expect(subject).to permit(project_manager)
    end

    it "denies access to guests" do
      expect(subject).not_to permit(guest)
    end
  end
end
