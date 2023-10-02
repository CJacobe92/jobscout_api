json.array! @employees do |data|
  json.merge! data.attributes.except(
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
end