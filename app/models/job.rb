class Job < ApplicationRecord
  self.primary_key = 'id'
  has_many :job_histories
  belongs_to :employer
  belongs_to :employee, optional: true

  validates :job_name, presence: true, on: :create
  validates :job_description, presence: true, on: :create
  validates :job_requirements, presence: true, on: :create
  validates :job_headcount, presence: true, on: :create
  validates :job_salary, presence: true, on: :create
  validates :job_currency, presence: true, on: :create
  validates :job_status, presence: true, on: :create
  validates :job_location, presence: true, on: :create
  validates :job_type, presence: true, on: :create
  validates :deadline, presence: true, on: :create
end
