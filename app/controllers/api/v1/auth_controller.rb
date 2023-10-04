require './app/services/account_finder'
require './app/services/token_helper'
require './app/services/headers_helper'

class Api::V1::AuthController < ApplicationController
  include ActionController::Cookies
  include AccountFinder
  include HeadersHelper
  include TokenHelper
  skip_before_action :authenticate, only: [:credentials, :password]
  
  def credentials
    credentials = params[:auth][:credentials]
    
    account = find_account(credentials)

    if account&.enabled
      payload = { email: account.email }
      token = encode_verification_token(payload)

      account.update(verification_token: token)

      cookies.signed[:verification] = {
        expires: 10.minutes.from_now,
        value: token,
        httponly: true,
        same_site: :none,
        secure: true
      }

      head :ok

    elsif account.nil?
      render json: { error: 'Account does not exist' }, status: :not_found
    else
      render json: {error: 'Account deactivated'}, status: :unauthorized
    end
  end

  def password
    token = cookies.signed[:verification]
    password = params[:auth][:password]
    result = decode_token(token)
    credentials = result['email']
    expiry = result['expiry']

    account = find_account(credentials)

    if account&.verification_token != token || Time.now > expiry
       render json: {error: 'Please sign in in again to continue'}, status: :unauthorized
    elsif account&.authenticate(password)
      handle_successful_signin(account)
    else
      render json: {error: 'Incorrect password'}, status: :unauthorized
    end
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

  def auth_params
    params.require(:auth).permit(:credentials, :password)
  end
end
