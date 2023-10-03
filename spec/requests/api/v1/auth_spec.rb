require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  describe "POST /signin" do
    context 'with correct email credentials' do
      let!(:admin) { create(:admin, enabled: true) }
      let!(:credentials) { {credential: admin.email, password: admin.password} }

      before do
        post '/api/v1/auth/signin', params: { auth: credentials }
      end
     
      it 'returns the correct response headers' do
        expect(expected_headers(response)).to_not be_nil
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with correct username credentials' do
      let!(:admin) {create(:admin, enabled: true)}
      let!(:credentials) { {credential: admin.username, password: admin.password} }

      before do
        post '/api/v1/auth/signin', params: { auth: credentials }
      end
     
      it 'returns the correct response headers' do
       expect(expected_headers(response)).to_not be_nil
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with incorrect credentials' do
      let!(:admin) {create(:admin, enabled: true)}
      let!(:credentials) { { credential: 'wrong_email', password: admin.password } }

      before do
        post '/api/v1/auth/signin', params: { auth: credentials }
      end
     
      it 'returns the error message' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with deactivated account' do
      let!(:admin) { create(:admin, enabled: false) }
      let!(:credentials) { { credential: admin.email , password: admin.password } }

      before do
        post '/api/v1/auth/signin', params: { auth: credentials }
      end
     
      it 'returns the error message' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with incorrect password' do
      let!(:admin) { create(:admin, enabled: true) }
      let!(:credentials) { { credential: admin.email , password: 'incorrect_password' } }

      before do
        post '/api/v1/auth/signin', params: { auth: credentials }
      end
     
      it 'returns the error message' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end


  # # helper methods

  def expected_headers(response)
    expect(response.headers['uid']).to_not be_nil
    expect(response.headers['authorization']).to_not be_nil
    expect(response.headers['client']).to_not be_nil
    expect(response.headers['enabled']).to_not be_nil
    expect(response.headers['otp_enabled']).to_not be_nil
    expect(response.headers['otp_required']).to_not be_nil
    expect(response.headers['role']).to_not be_nil   
  end
end
