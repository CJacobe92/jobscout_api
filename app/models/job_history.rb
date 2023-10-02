class JobHistory < ApplicationRecord
  self.primary_key = 'id'
  belongs_to :employer
  belongs_to :job

  validates :job_name, presence: true, on: :create
  validates :job_location, presence: true, on: :create
  validates :job_salary, presence: true, on: :create
  validates :job_currency, presence: true, on: :create
  validates :job_headcount, presence: true, on: :create
  validates :job_type, presence: true, on: :create
  validates :job_status, presence: true, on: :create
end
