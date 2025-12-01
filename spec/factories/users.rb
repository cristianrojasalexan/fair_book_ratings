FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    banned { false }

    trait :banned do
      banned { true }
    end
  end
end