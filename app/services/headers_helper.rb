module HeadersHelper
  def response_headers(account, access_token)
    response.headers.merge!(
      "uid" => account&.id,
      "authorization" => access_token,
      "client" => 'Jobscout',
      "enabled" => account&.enabled,
      "otp_enabled" =>  account&.otp_enabled,
      "otp_required" => account&.otp_required,
      "user_type" => account&.role
    )
  end
end