class Tenant < ApplicationRecord
  self.primary_key = 'id'
  has_many :employers
  has_many :employees
  has_many :job_histories
  has_many :owners

  validates :company_name, presence: true, on: :create, uniqueness: true
  validates :principal, presence: true, on: :create
  validates :company_address, presence: true, on: :create
  validates :company_email, presence: true, on: :create
  validates :license, presence: true, on: :create
  validates :contact_number, presence: true, on: :create
  validates :subscription, presence: true, on: :create
end
