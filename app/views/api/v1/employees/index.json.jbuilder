json.data do
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
end 

json.meta do
  json.total_pages @employees.total_pages
  json.current_page @employees.current_page
  json.per_page @employees.limit_value
  json.total_count @employees.total_count
end