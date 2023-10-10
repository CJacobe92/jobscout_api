class Job < ApplicationRecord
  self.primary_key = 'id'
  has_many :job_histories
  has_many :applicants
  belongs_to :employer

  validates :job_name, presence: true, on: :create
  validates :job_description, presence: true, on: :create
  validates :job_requirement, presence: true, on: :create
  validates :job_headcount, presence: true, on: :create
  validates :job_salary, presence: true, on: :create
  validates :job_currency, presence: true, on: :create
  validates :job_location, presence: true, on: :create
  validates :job_type, presence: true, on: :create
  validates :deadline, presence: true, on: :create
end
