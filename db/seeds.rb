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