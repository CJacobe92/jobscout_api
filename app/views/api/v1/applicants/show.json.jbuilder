json.merge! @current_applicant.attributes.except(
  'password_digest', 
  'access_token',
  'refresh_token',
  'reset_token',
  'otp_secret_key',
  'enabled',
  'otp_enabled',
  'otp_required',
  'activation_token'
)