# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
admin = Admin.create!(
  firstname: 'global',
  lastname: 'admin',
  email: 'global.admin@email.com',
  username: 'global.admin',
  password: 'password',
  password_confirmation: 'password',
  enabled: true,
  otp_required: false,
  otp_enabled: true
)

owner = Owner.create!(
  firstname: 'test',
  lastname: 'owner',
  username: 'test.owner',
  email: 'test.owner@email.com',
  password: 'password',
  password_confirmation: 'password',
  enabled: true,
  otp_required: true,
  otp_enabled: true,
)

tenant = Tenant.create!(
  company_name: 'Test Manpower Services Inc.',
  company_owner: 'Test Owner',
  company_address: 'company address',
  company_email: 'testmanpowerservices@agency.com',
  license: '123456789',
  contact_number: '987654321',
  subscription: 'enterprise',
  owner_id: owner && owner.id
)

employee = Employee.create!(
  firstname: 'test',
  lastname: 'employee',
  username: 'test.employee',
  email: 'test.employee@email.com',
  password: 'password',
  password_confirmation: 'password',
  enabled: true,
  otp_required: true,
  otp_enabled: true,
  tenant_id: tenant && tenant.id
)

employer = Employer.create!(
  firstname: 'test',
  lastname: 'employer',
  username: 'test.employer',
  email: 'test.employer@email.com',
  password: 'password',
  password_confirmation: 'password',
  enabled: true,
  otp_required: true,
  otp_enabled: true,
  tenant_id: tenant && tenant.id
)

applicant = Applicant.create!(
  firstname: 'test1',
  lastname: 'applicant',
  username: 'test1.applicant',
  email: 'test1.applicant@email.com',
  password: 'password',
  password_confirmation: 'password',
  enabled: true,
  otp_required: true,
  otp_enabled: true,
)

applicant = Applicant.create!(
  firstname: 'test2',
  lastname: 'applicant',
  username: 'test2.applicant',
  email: 'test2.applicant@email.com',
  password: 'password',
  password_confirmation: 'password',
  enabled: true,
  otp_required: true,
  otp_enabled: true,
)