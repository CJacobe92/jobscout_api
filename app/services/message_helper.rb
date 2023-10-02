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
  
  DELETION_FAILED = {
    error: 'Resource deletion failed',
    error_description: 'Record deletion failed due to invalid parameters.'
  }.freeze
end