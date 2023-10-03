class Employer < ApplicationRecord
  self.primary_key = 'id'
  has_many :job_histories
  has_many :applicants
  belongs_to :tenant

  validates :company_name, presence: true, uniqueness: true, on: :create
  validates :company_hq, presence: true, on: :create
  validates :company_email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create
  validates :company_phone, presence: true, on: :create
  validates :company_poc, presence: true, on: :create
  
end
