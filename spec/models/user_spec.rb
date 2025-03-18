require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(admin: 0, project_manager: 1, developer: 2) }

    it "correctly assigns roles" do
      admin = User.new(email: "admin@example.com", password: "password", role: :admin)
      pm = User.new(email: "pm@example.com", password: "password", role: :project_manager)
      dev = User.new(email: "dev@example.com", password: "password", role: :developer)

      expect(admin.admin?).to be true
      expect(pm.project_manager?).to be true
      expect(dev.developer?).to be true
    end

    it "does not assign invalid roles" do
      expect { User.new(email: "invalid@example.com", password: "password", role: :invalid_role) }
        .to raise_error(ArgumentError)
    end
  end
end
