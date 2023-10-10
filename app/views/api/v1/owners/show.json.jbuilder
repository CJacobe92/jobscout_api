json.merge! @current_owner.attributes.except(
  'username',
  'role',
  'password_digest', 
  'access_token',
  'refresh_token',
  'reset_token',
  'otp_secret_key',
  'enabled',
  'otp_enabled',
  'otp_required',
  'activation_token',
  'verification_token',
  'created_at',
  'updated_at'
)
