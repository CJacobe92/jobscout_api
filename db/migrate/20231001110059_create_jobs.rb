class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs, id: :uuid do |t|
      t.string :job_name
      t.text :job_description
      t.text :job_requirements
      t.integer :job_headcount
      t.string :job_salary
      t.string :job_currency
      t.string :job_status
      t.string :job_location
      t.string :tags
      t.string :job_type
      t.date :deadline

      # uuid
      t.uuid :employer_id, null: false
      t.uuid :applicant_id, null: true
      t.uuid :employee_id, null: true

      t.timestamps
    end

    add_foreign_key :jobs, :employers, column: :employer_id
    add_foreign_key :jobs, :applicants, column: :applicant_id
    add_foreign_key :jobs, :employees, column: :employee_id

  end
end
