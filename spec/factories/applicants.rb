FactoryBot.define do
  factory :applicant do
    sequence(:firstname) { |n| "test#{n}" }
    sequence(:lastname) { "applicant" }
    sequence(:username) { |n| "test#{n}.applicant" }
    sequence(:email) { |n| "test#{n}.applicant@email.com"}
    sequence(:password) { "password" }
    sequence(:password_confirmation) { "password" }
  end
end
