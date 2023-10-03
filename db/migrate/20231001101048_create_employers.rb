class CreateEmployers < ActiveRecord::Migration[7.0]
  def change
    create_table :employers, id: :uuid do |t|
      t.string :company_name
      t.string :company_hq
      t.string :company_address
      t.string :company_email
      t.string :company_phone
      t.string :company_poc

      #uuid
      t.references :tenant, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end    
  end
end
