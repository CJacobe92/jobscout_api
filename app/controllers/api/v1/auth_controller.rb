require './app/services/account_finder'
require './app/services/token_helper'
require './app/services/headers_helper'

class Api::V1::AuthController < ApplicationController
  include ActionController::Cookies
  include AccountFinder
  include HeadersHelper
  include TokenHelper
  skip_before_action :authenticate, only: [:signin]
  

  def signin
    credential  = params[:auth][:credential]
    password = params[:auth][:password]

    find_and_authenticate_user(credential, password)
  end

  private

  def find_and_authenticate_user(credential, password)
    account = find_account(credential)

    if account&.enabled && account&.authenticate(password)
      handle_successful_signin(account)
    else
      handle_failed_signin(account)
    end
  end

  def handle_successful_signin(account)
    payload = {email: account&.email, type: account&.class.name}
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

  def handle_failed_signin(account)
    if account.nil?
      render json: { error: 'Account does not exist' }, status: :unauthorized
    elsif !account.enabled
      render json: { error: 'Account disabled' }, status: :unauthorized
    else
      render json: { error: 'Incorrect password' }, status: :unauthorized
    end
  end

  def auth_params
    params.require(:auth).permit(:credential, :password)
  end
end
