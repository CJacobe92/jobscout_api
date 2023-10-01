FactoryBot.define do
  factory :job do
    sequence(:job_name) { |n| "Job name#{n}" }
    sequence(:job_description) { |n| "Job Description#{n}" }
    sequence(:job_requirements) { |n| "Job Requirement#{n}" }
    sequence(:job_headcount) { "100" }
    sequence(:job_salary)  { "1000" }
    sequence(:job_currency) { "USD" }
    sequence(:job_status) { "Active" }
    sequence(:job_location) { "California, USA" }
    sequence(:tags) { "Engineering" }
    sequence(:job_type) { "Full Time" }
    sequence(:deadline) { "2023-09-17" }
  end
end
