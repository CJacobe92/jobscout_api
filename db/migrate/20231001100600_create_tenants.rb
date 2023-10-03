class CreateTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :tenants, id: :uuid do |t|
      t.string :company_name
      t.string :company_address
      t.string :principal
      t.string :company_email
      t.string :license
      t.string :contact_number
      t.string :subscription
      t.string :subdomain
      t.boolean :activated, defaut: -> { false }
  
      t.timestamps
    end
  end
end
