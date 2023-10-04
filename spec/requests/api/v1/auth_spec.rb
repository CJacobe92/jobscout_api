require 'rails_helper'

RSpec.describe "Api::V1::Auth", type: :request do
  include ActionController::Cookies

  describe "POST /credentials" do
    context 'with correct email credentials' do
      let!(:admin) { create(:admin, enabled: true) }
      let!(:credentials) { {credentials: admin.email } }

      before do
        post '/api/v1/auth/credentials', params: { auth: credentials }
      end

      it 'returns 200 status if account is present' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns 404 status if account does not exist' do
        post '/api/v1/auth/credentials', params: { auth: {credentials: 'non_existing_email@email.com'} }

        expect(response).to have_http_status(:not_found)
      end

      it 'returns 404 status if account does not exist' do
        disabled_admin = create(:admin)
        credentials = {credentials: disabled_admin.email } 

        post '/api/v1/auth/credentials', params: { auth: credentials }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # # # helper methods

  # def expected_headers(response)
  #   expect(response.headers['uid']).to_not be_nil
  #   expect(response.headers['authorization']).to_not be_nil
  #   expect(response.headers['client']).to_not be_nil
  #   expect(response.headers['enabled']).to_not be_nil
  #   expect(response.headers['otp_enabled']).to_not be_nil
  #   expect(response.headers['otp_required']).to_not be_nil
  #   expect(response.headers['role']).to_not be_nil   
  # end
end
