FactoryBot.define do
  factory :task do
    title { "Test Task" }
    status { :to_do }
    association :project
  end
end
