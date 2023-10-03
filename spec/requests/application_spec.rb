require 'rails_helper'

RSpec.describe "ApplicationController", type: :request do

  describe 'authenticate' do
    
    let!(:admin) { create(:admin) }

    context 'token_request' do
      it 'returns forbidden when header is blank' do
        get "/api/v1/admins", headers: { "Authorization" => ""}

        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden when header length is not equal to 2' do
        malformed_auth_header = encode_access_token(email: admin.email, role: admin.role)

        get "/api/v1/admins", headers: { "Authorization" => malformed_auth_header}

        expect(response).to have_http_status(:forbidden)
      end

      
      it 'returns forbidden when header scheme is missing Bearer prefix' do
        bad_credential = "BAD_CREDENTIAL " + encode_access_token(email: admin.email, role: admin.role)

        get "/api/v1/admins", headers: { "Authorization" => bad_credential }

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'validate_token' do
      it "returns 401 when the token is expired" do
        expiry = (Time.now - 48.hours).iso8601()
        payload = { email: admin.email, role: admin.role, expiry: expiry }
        headers = JWT.encode(payload, Rails.application.credentials.secret_key_base)
        admin.update(access_token: headers)

        get "/api/v1/admins", headers: { 'Authorization' => "Bearer #{headers}" }

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns 401 when the token mismatched" do
        header = encode_access_token(email: admin.email, role: admin.role)

        get "/api/v1/admins", headers: { 'Authorization' => "Bearer #{header}" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end