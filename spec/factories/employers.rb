FactoryBot.define do
  factory :employer do
    sequence(:company_name) { |n| "test#{n}" }
    sequence(:company_hq) { |n| "company hq#{n}" }
    sequence(:company_email) { |n| "company#{n}.email@email.com"}
    sequence(:company_phone) { "12345678" }
    sequence(:company_poc) { "John Doe" }
  end
end
