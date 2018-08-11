FactoryBot.define do
  factory :user do
    first_name "John"
    last_name "Doe"
    sequence(:email) { |n| "user#{n}@example.com" }
    is_admin false
    password "dummy"
    factory :admin do
      is_admin true
    end
  end
end
