FactoryBot.define do
  factory :owner do
    sequence(:firstname) { |n| "test#{n}" }
    sequence(:lastname) { "owner" }
    sequence(:username) { |n| "test#{n}.owner" }
    sequence(:email) { |n| "test#{n}.owner@email.com"}
    sequence(:password) { "password" }
    sequence(:password_confirmation) { "password" }
  end
end
