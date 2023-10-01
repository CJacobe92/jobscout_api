FactoryBot.define do
  factory :tenant do
    sequence(:company_name) { |n| "company#{n}" }
    sequence(:company_owner) { |n| "tenant user#{n}"}
    sequence(:company_address) { |n| "address#{n}" } 
    sequence(:company_email) { |n| "tenant#{n}@company.com"}
    sequence(:license) { |n| "license#{n}" }
    sequence(:contact_number) { |n| "number#{n}" } 
    sequence(:subscription) { "subscription" }
    sequence(:subdomain) { |n| "subdomain_name#{n}" }
  end
end
