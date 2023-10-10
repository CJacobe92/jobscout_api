module HeadersHelper
  def response_headers(account, token)
    response_headers = {
      "uid" => account&.id,
      "authorization" => token,
      "client" => 'Jobscout',
      "enabled" => account&.enabled,
      "otp_enabled" => account&.otp_enabled,
      "otp_required" => account&.otp_required,
      "role" => account&.role
    }

    if account.class.name == 'Owner' || account.class.name == 'Employee'
      response_headers["tenant_id"] = account&.tenant_id
    end

    response.headers.merge!(response_headers)
  end
end
