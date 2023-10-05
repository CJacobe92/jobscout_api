module MessageHelper
  REQUIRES_AUTHENTICATION = {message: 'Requires authentication'}.freeze

  BAD_CREDENTIALS = { message: 'Bad credentials' }.freeze

  MALFORMED_AUTHORIZATION_HEADER = {
    error: 'Malformed header',
    error_description: 'Authorization header value must follow this format: Bearer access-token',
    message: 'Bad credentials'
  }.freeze

  EXPIRED_TOKEN = {
    error: 'Invalid Token',
    error_description: 'Authenticating using an expired token',
    message: 'Bad credentials'
  }.freeze

  MISMATCHED_TOKEN = {
    error: 'Token mismatched',
    message: 'Bad credentials'
  }.freeze

  UNAUTHORIZED = {
    error: 'Unauthorized access',
    error_description: 'You are accessing a protected resource.'
  }.freeze
  
  CREATED = {
    message: 'Resource created',
    description: 'Record created successfully.'
  }.freeze
  
  UNPROCESSABLE_ENTITY = {
    error: 'Resource creation or update failed',
    error_description: 'Record creation or update failed due to invalid parameters.'
  }.freeze
  
  EXPIRED_REFRESH_TOKEN = {
    error: 'Invalid refresh Token',
    error_description: 'Authenticating using an expired token',
    message: 'Bad credentials'
  }.freeze

  MISMATCHED_REFRESH_TOKEN = {
    error: 'Refresh token mismatched',
    message: 'Bad credentials'
  }.freeze

  MISSING_COOKIE_VALUE = {
    error: 'Empty cookie',
    error_description: 'Blank cookie value',
  }

  MALFORMED_COOKIE_VALUE = {
    error: 'Malformed cookie',
    error_description: 'Cookie value length did not match the requirements',
  }
  
end