module TokenHelper
  def encode_access_token(payload)
    payload[:expiry] = (Time.now + 1.hour).iso8601
    return access_token = JWT.encode(payload, secret_key)
  end

  def encode_verification_token(payload)
    payload[:expiry] = (Time.now + 8.hours).iso8601
    return verification_token = JWT.encode(payload, secret_key)
  end

  def encode_li_refresh_token(payload)
    payload[:expiry] = (Time.now + 60.days).iso8601
    return li_refresh_token = JWT.encode(payload, secret_key)
  end

  def encode_refresh_token(payload)
    payload[:expiry] = (Time.now + 24.hours).iso8601
    return refresh_token = JWT.encode(payload, secret_key)
  end

  def encode_activation_token(payload)
    payload[:expiry] = (Time.now + 1.day).iso8601
    return activation_token = JWT.encode(payload, secret_key)
  end

  def decode_token(payload)
    decoded_token = JWT.decode(payload, secret_key, true).first
  end

  def secret_key
    Rails.application.credentials.secret_key_base
  end
end