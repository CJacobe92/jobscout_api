require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  include ActionController::Cookies

  describe 'post #password' do
    let!(:admin) { create(:admin, enabled: true) }

    context 'with token from cookies' do
      it 'with correct password and valid verification token' do

        payload = {email: admin.email}
        token = encode_verification_token(payload)
        admin.update(verification_token: token)
        cookies.signed[:verification] = token
        
        params = { auth: {password: 'password'} }
        post :password, params: params

        expect(response).to have_http_status(:ok)
      end

      it 'returns 401 status for invalid and expired verification token' do
        expiry = (Time.now - 48.hours).iso8601()
        payload = { email: admin.email, expiry: expiry }
        token = JWT.encode(payload, Rails.application.credentials.secret_key_base)
        
        cookies.signed[:verification] = token
        params = { auth: {password: 'password'} }
        post :password, params: params

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 401 status incorrect password' do 
        payload = {email: admin.email}
        token = encode_verification_token(payload)
        admin.update(verification_token: token)
        cookies.signed[:verification] = token

        params = { auth: {password: 'wrong_password'} }
        post :password, params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
