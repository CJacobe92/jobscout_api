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
      t.references :employer, null: false, type: :uuid, foreign_key: true
      t.references :employee, null: true, type: :uuid, foreign_key: true


      t.timestamps
    end
  end
end
