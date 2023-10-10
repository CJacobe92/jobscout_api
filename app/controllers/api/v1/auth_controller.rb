require './app/services/account_finder'
require './app/services/token_helper'
require './app/services/headers_helper'

class Api::V1::AuthController < ApplicationController
  include ActionController::Cookies
  include AccountFinder
  include HeadersHelper
  include TokenHelper
  skip_before_action :authenticate, only: [:credentials, :password, :refresh]
  
  def credentials
    credentials = params[:auth][:credentials]
    
    account = find_account(credentials)

    if account&.enabled
      payload = { email: account.email }
      token = encode_verification_token(payload)

      account.update(verification_token: token)
      response_headers(account, token)

      render json: { account: account.email}, status: :ok

    elsif account.nil?
      render json: { error: 'Account does not exist' }, status: :not_found
    else
      render json: {error: 'Account deactivated'}, status: :unauthorized
    end
  end

  def password
    token = params[:token]
    password = params[:auth][:password]
    result = decode_token(token)
    credentials = result['email']
    expiry = result['expiry']

    account = find_account(credentials)

    if account&.email != credentials || Time.now > expiry

      cookies.delete(:verification, {
        httponly: true,
        same_site: :none,
        secure: true
      })
  
       render json: {error: 'Invalid access'}, status: :unauthorized
    elsif account&.authenticate(password)
      handle_successful_signin(account)

    else
      render json: {error: 'Incorrect password'}, status: :unauthorized
    end
  end

  def refresh
    result = token_from_cookies
    account = validate_refresh_token(result)
    
    payload = {email: account.email, role: account.role}
    access_token = encode_access_token(payload)
    account&.update(access_token: access_token)
    response_headers(account, access_token)

    head :ok 
  end

  private

  def handle_successful_signin(account)
    payload = {email: account&.email, role: account.role}
    access_token = encode_access_token(payload)
    refresh_token = encode_refresh_token(payload)

    account&.update(refresh_token: refresh_token, access_token: access_token)

    cookies.signed[:refresh_token] = {
      expires: 7.days.from_now,
      value: refresh_token,
      httponly: true,
      same_site: :none,
      secure: true
    }

    response_headers(account, access_token)

    render json: { message: 'Login success', access_token: access_token }, status: :ok
  end

  def token_from_cookies
    token = cookies.signed[:refresh_token]
    
    if token.blank?
      render json: MISSING_COOKIE_VALUE, status: :unauthorized
    elsif token&.split('.')&.length != 3
      render json: MALFORMED_COOKIE_VALUE, status: :unauthorized
    end

    token
  end
  
  def validate_refresh_token(token)
    result = decode_token(token)
    expiry = result['expiry']
    email = result['email']
    account = find_account(email)

    if account.nil?
      render json: BAD_CREDENTIALS, status: :unauthorized
    elsif account.refresh_token != token
      render json: MISMATCHED_REFRESH_TOKEN, status: :unauthorized
    elsif expiry < Time.now
      render json: EXPIRED_REFRESH_TOKEN, status: :unauthorized
    end

    account
  end

  def expire_refresh_token_cookie
    cookies.delete(:refresh_token)
  end

  def auth_params
    params.require(:auth).permit(:credentials, :password)
  end
end
