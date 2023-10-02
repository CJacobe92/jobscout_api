class CreateJobHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :job_histories, id: :uuid do |t|
      t.string :job_name
      t.string :job_location
      t.string :job_salary
      t.string :job_currency
      t.string :job_headcount
      t.string :job_type
      t.string :job_status
      t.string :employer_name

      #uuid
      t.references :employer, null: false, type: :uuid, foreign_key: true
      t.references :job, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
