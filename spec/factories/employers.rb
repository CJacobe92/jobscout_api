FactoryBot.define do
  factory :employer do
    sequence(:firstname) { |n| "test#{n}" }
    sequence(:lastname) { "employer" }
    sequence(:username) { |n| "test#{n}.employer" }
    sequence(:email) { |n| "test#{n}.employer@email.com"}
    sequence(:password) { "password" }
    sequence(:password_confirmation) { "password" }
  end
end
