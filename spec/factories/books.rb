FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Book #{n}" }
    sequence(:author) { |n| "Author #{n}" }
  end
end
