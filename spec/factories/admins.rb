FactoryBot.define do
  factory :admin do
    sequence(:firstname) { |n| "test#{n}" }
    sequence(:lastname) { "admin" }
    sequence(:username) { |n| "test#{n}.admin" }
    sequence(:email) { |n| "test#{n}.admin@email.com"}
    sequence(:password) { "password" }
    sequence(:password_confirmation) { "password" }
  end
end
