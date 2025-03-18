FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }

    trait :admin do
      role { :admin }
    end

    trait :project_manager do
      role { :project_manager }
    end

    trait :developer do
      role { :developer }
    end
  end
end
