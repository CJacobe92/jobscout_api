class CreateJobApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :job_applications, id: :uuid do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :job_name
      t.string :company_name
      t.string :job_location
      t.string :job_type
      t.string :status, default: 'applied'
   
      #uuid
      t.references :applicant, null: false, type: :uuid, foreign_key: true
      t.references :job, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
