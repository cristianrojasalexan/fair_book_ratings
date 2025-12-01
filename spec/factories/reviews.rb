FactoryBot.define do
  factory :review do
    association :book
    association :user
    rating { rand(1..5) }
    content { 'Good book' }

    trait :from_banned_user do
      association :user, factory: [:user, :banned]
    end

    trait :long_content do
      content { 'a' * 1001 }
    end
  end
end
