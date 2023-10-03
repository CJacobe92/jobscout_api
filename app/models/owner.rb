class Owner < ApplicationRecord
  self.primary_key = 'id'
  has_secure_password
  belongs_to :tenant

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :create
  validates :password, presence: true, length: {minimum: 8}, if: -> { password.present? }, on: :create
  validates :password_confirmation, presence: true, on: :create

end
