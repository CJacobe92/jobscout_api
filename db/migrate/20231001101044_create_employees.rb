class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees, id: :uuid do |t|
      t.string :firstname
      t.string :lastname
      t.string :username
      t.string :email
      t.string :password_digest
    
      # role
      t.string :role, default: 'employee'

      # tokens and secrets
      t.string :reset_token 
      t.string :activation_token
      t.string :refresh_token
      t.string :access_token
      t.string :otp_secret_key

      # booleans
      t.boolean :enabled, default: -> { false }
      t.boolean :otp_enabled, default: -> { false }
      t.boolean :otp_required, default: -> { true }
      
      #uuid
      t.uuid :tenant_id, null: false

      t.timestamps
    end

    add_foreign_key :employees, :tenants, column: :tenant_id

  end
end
