class CreateTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :tenants, id: :uuid do |t|
      t.string :company_name
      t.string :company_owner
      t.string :company_address
      t.string :company_email
      t.string :license
      t.string :contact_number
      t.string :subscription
      t.string :subdomain
      t.boolean :activated, defaut: -> { false }

      # uuid
      t.uuid :owner_id, null: false

      t.timestamps
    end

    add_foreign_key :tenants, :owners, column: :owner_id
  end
end
