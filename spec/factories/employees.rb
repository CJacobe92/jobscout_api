FactoryBot.define do
  factory :employee do
    sequence(:firstname) { |n| "test#{n}" }
    sequence(:lastname) { "employee" }
    sequence(:username) { |n| "test#{n}.employee" }
    sequence(:email) { |n| "test#{n}.employee@email.com"}
    sequence(:password) { "password" }
    sequence(:password_confirmation) { "password" }
  end
end
