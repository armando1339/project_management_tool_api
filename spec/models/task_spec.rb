require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:project) { create(:project) }

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
    it { should define_enum_for(:status).with_values(to_do: 0, in_progress: 1, done: 2) }
  end

  describe "associations" do
    it { should belong_to(:project) }
    it { should belong_to(:assigned_user).class_name('User').optional }
  end

  describe "enums" do
    it "correctly assigns statuses" do
      task_to_do = Task.new(title: "Task To Do", status: :to_do, project: project)
      task_in_progress = Task.new(title: "Task In Progress", status: :in_progress, project: project)
      task_done = Task.new(title: "Task Done", status: :done, project: project)

      expect(task_to_do.to_do?).to be true
      expect(task_in_progress.in_progress?).to be true
      expect(task_done.done?).to be true
    end

    it "does not allow invalid statuses" do
      expect { Task.new(title: "Invalid Task", status: :invalid_status, project: project) }
        .to raise_error(ArgumentError)
    end
  end
end
