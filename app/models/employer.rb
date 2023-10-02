class Employer < ApplicationRecord
  self.primary_key = 'id'
  has_secure_password
  has_many :job_histories
  has_many :applicants
  belongs_to :tenant


  validates :firstname, presence: true, on: :create
  validates :lastname, presence: true, on: :create
  validates :username, presence: true, on: :create
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create
  validates :password, presence: true, length: {minimum: 8}, if: -> { password.present? }, on: :create
  validates :password_confirmation, presence: true, on: :create
  
end
