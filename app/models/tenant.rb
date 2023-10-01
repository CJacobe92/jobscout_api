class Tenant < ApplicationRecord
  has_many :employers
  has_many :employees
  belongs_to :owner

 validates :company_name, presence: true, on: :create
 validates :company_owner, presence: true, on: :create
 validates :company_address, presence: true, on: :create
 validates :company_email, presence: true, on: :create
 validates :license, presence: true, on: :create
 validates :contact_number, presence: true, on: :create
 validates :subscription, presence: true, on: :create
 validates :subdomain, presence: true, on: :create
end
