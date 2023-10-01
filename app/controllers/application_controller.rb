require './app/services/account_finder'
require './app/services/token_helper'

class ApplicationController < ActionController::API
  include AccountFinder
  include TokenHelper

  before_action :authenticate

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

  def authenticate
    token = token_from_request

    if token
    
      validation_response = validate_token(token)
      type = validation_response[:type].downcase();
      user = validation_response[:account]
      

      @current_user = user if user.role == type

    end
  end


  private

  def token_from_request
    authorization_header = request.headers['Authorization']&.split

    if authorization_header.blank?
      render json: REQUIRES_AUTHENTICATION, status: :forbidden
      return
    end

    unless authorization_header.length == 2
      render json: MALFORMED_AUTHORIZATION_HEADER, status: :forbidden and return
    end

   scheme, token = authorization_header

   render json: BAD_CREDENTIALS, status: :forbidden and return unless scheme.downcase == 'bearer'

   token
  end

  def validate_token(token)
    begin
      result = decode_token(token)
      expiry = result['expiry']
      email = result['email']
      account = find_account(email)

  
      if expiry < Time.now
        render json: EXPIRED_TOKEN, status: :unauthorized
      elsif account&.access_token != token
        render json: MISMATCHED_TOKEN, status: :unauthorized
      end
    
      { account: account, type: result['type'] }
    end
  end  
   

end
