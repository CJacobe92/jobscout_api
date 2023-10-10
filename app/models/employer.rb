class Employer < ApplicationRecord
  self.primary_key = 'id'
  has_many :job_histories
  has_many :applicants
  has_many :jobs
  belongs_to :tenant

  validates :company_name, presence: true, uniqueness: true, on: :create
  validates :company_address, presence: true, on: :create
  validates :company_email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create
  validates :company_phone, presence: true, on: :create
  validates :company_poc_name, presence: true, on: :create
  validates :company_poc_title, presence: true, on: :create

  
end
