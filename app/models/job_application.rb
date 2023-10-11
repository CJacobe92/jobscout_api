class JobApplication < ApplicationRecord
  self.primary_key = 'id'
  belongs_to :applicant
  belongs_to :job

  validates :firstname, presence: true, on: :create
  validates :lastname, presence: true, on: :create
  validates :email, presence: true, on: :create
  validates :company_name, presence: true, on: :create
  validates :job_name, presence: true, on: :create
  validates :job_location, presence: true, on: :create
  validates :job_type, presence: true, on: :create
  validates :status, presence: true, on: :create
end
