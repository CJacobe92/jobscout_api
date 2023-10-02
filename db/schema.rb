# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_02_101180) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "role", default: "admin"
    t.string "reset_token"
    t.string "activation_token"
    t.string "refresh_token"
    t.string "access_token"
    t.string "otp_secret_key"
    t.boolean "enabled", default: false
    t.boolean "otp_enabled", default: false
    t.boolean "otp_required", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "applicants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "role", default: "applicant"
    t.string "reset_token"
    t.string "activation_token"
    t.string "refresh_token"
    t.string "access_token"
    t.string "otp_secret_key"
    t.boolean "enabled", default: false
    t.boolean "otp_enabled", default: false
    t.boolean "otp_required", default: true
    t.uuid "job_id"
    t.uuid "employer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employer_id"], name: "index_applicants_on_employer_id"
    t.index ["job_id"], name: "index_applicants_on_job_id"
  end

  create_table "employees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "role", default: "employee"
    t.string "reset_token"
    t.string "activation_token"
    t.string "refresh_token"
    t.string "access_token"
    t.string "otp_secret_key"
    t.boolean "enabled", default: false
    t.boolean "otp_enabled", default: false
    t.boolean "otp_required", default: true
    t.uuid "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_employees_on_tenant_id"
  end

  create_table "employers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "role", default: "employers"
    t.string "reset_token"
    t.string "activation_token"
    t.string "refresh_token"
    t.string "access_token"
    t.string "otp_secret_key"
    t.boolean "enabled", default: false
    t.boolean "otp_enabled", default: false
    t.boolean "otp_required", default: true
    t.uuid "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_employers_on_tenant_id"
  end

  create_table "job_histories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "job_name"
    t.string "job_location"
    t.string "job_salary"
    t.string "job_currency"
    t.string "job_headcount"
    t.string "job_type"
    t.string "job_status"
    t.string "employer_name"
    t.uuid "employer_id", null: false
    t.uuid "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employer_id"], name: "index_job_histories_on_employer_id"
    t.index ["job_id"], name: "index_job_histories_on_job_id"
  end

  create_table "jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "job_name"
    t.text "job_description"
    t.text "job_requirements"
    t.integer "job_headcount"
    t.string "job_salary"
    t.string "job_currency"
    t.string "job_status"
    t.string "job_location"
    t.string "tags"
    t.string "job_type"
    t.date "deadline"
    t.uuid "employer_id", null: false
    t.uuid "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_jobs_on_employee_id"
    t.index ["employer_id"], name: "index_jobs_on_employer_id"
  end

  create_table "owners", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "role", default: "owner"
    t.string "reset_token"
    t.string "activation_token"
    t.string "refresh_token"
    t.string "access_token"
    t.string "otp_secret_key"
    t.boolean "enabled", default: false
    t.boolean "otp_enabled", default: false
    t.boolean "otp_required", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tenants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "company_name"
    t.string "company_owner"
    t.string "company_address"
    t.string "company_email"
    t.string "license"
    t.string "contact_number"
    t.string "subscription"
    t.string "subdomain"
    t.boolean "activated"
    t.uuid "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_tenants_on_owner_id"
  end

  add_foreign_key "applicants", "employers"
  add_foreign_key "applicants", "jobs"
  add_foreign_key "employees", "tenants"
  add_foreign_key "employers", "tenants"
  add_foreign_key "job_histories", "employers"
  add_foreign_key "job_histories", "jobs"
  add_foreign_key "jobs", "employees"
  add_foreign_key "jobs", "employers"
  add_foreign_key "tenants", "owners"
end
