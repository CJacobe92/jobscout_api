class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs, id: :uuid do |t|
      t.string :job_name
      t.text :job_description
      t.text :job_requirement
      t.integer :job_headcount
      t.integer :hired, default: 0
      t.string :job_salary
      t.string :job_currency
      t.string :job_status, default: 'new'
      t.string :job_location
      t.string :tags
      t.string :job_type
      t.string :assignment, default: 'unassigned'
      t.date :deadline

      # uuid
      t.references :employer, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
