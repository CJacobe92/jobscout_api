require 'rails_helper'

RSpec.describe "Api::V1::Admins", type: :request do

  describe "GET /index" do
    let!(:existing_admins) { create_list(:admin, 10) }
    let!(:accessing_admin) { create(:admin) }

    context 'with correct authorization' do
      before do
        get '/api/v1/admins', headers: { 'Authorization' => access_token(accessing_admin)}
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct response body' do
        restricted_parameters = %w[
          password_digest
          access_token
          refresh_token
          reset_token
          otp_secret_key
          enabled
          otp_enabled
          otp_required
          activation_token
        ]

        json.map do |data| 
          expect(data).not_to include(restricted_parameters)
        end
      end
    end
  end

  describe "POST /create" do
    let!(:accessing_admin) { create(:admin) }

    context 'with correct authorization' do
      before do
        params = { admin: attributes_for(:admin) }
        post '/api/v1/admins', headers: { 'Authorization' => access_token(accessing_admin)}, params: params
      end

      it 'with correct parameters returns 201 status' do
        expect(response).to have_http_status(:created)
      end

      it 'with incorrect parameters returns 422 status' do
        incorrect_params = {admin: { incorrect_key: 'incorrect_params' } }
        post '/api/v1/admins', headers: { 'Authorization' => access_token(accessing_admin)}, params: incorrect_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /show" do
    let!(:accessing_admin) { create(:admin) }

    context 'with correct authorization' do
      before do
        get "/api/v1/admins/#{accessing_admin.id}", headers: { 'Authorization' => access_token(accessing_admin)}
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct response body' do
        restricted_parameters = %w[
          password_digest
          access_token
          refresh_token
          reset_token
          otp_secret_key
          enabled
          otp_enabled
          otp_required
          activation_token
        ]

        expect(json).not_to include(restricted_parameters)
      end

      it 'returns not found when resource does not exist' do
        get "/api/v1/admins/99999", headers: { 'Authorization' => access_token(accessing_admin)}
        expect(json['error']).to eq('Resource not found')
      end
    end
  end

  describe "PATCH /update" do
    let!(:accessing_admin) { create(:admin) }

    context 'with correct authorization' do
      before do
        params = { admin: { firstname: 'root' } }
        patch "/api/v1/admins/#{accessing_admin.id}", headers: { 'Authorization' => access_token(accessing_admin)}, params: params
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct response body' do
        restricted_parameters = %w[
          password_digest
          access_token
          refresh_token
          reset_token
          otp_secret_key
          enabled
          otp_enabled
          otp_required
          activation_token
        ]

        expect(json).not_to include(restricted_parameters)
        expect(json['firstname']).to include('root')
      end

      it 'returns not found when resource does not exist' do
        get "/api/v1/admins/99999", headers: { 'Authorization' => access_token(accessing_admin)}
        expect(json['error']).to eq('Resource not found')
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:accessing_admin) { create(:admin) }
    let!(:terminated_admin) { create(:admin) }


    context 'with correct authorization' do
      before do
        delete "/api/v1/admins/#{terminated_admin.id}", headers: { 'Authorization' => access_token(accessing_admin)}
      end

      it 'returns no content' do
        expect(response).to have_http_status(:no_content)
      end

      it 'returns not found when resource does not exist' do
        get "/api/v1/admins/99999", headers: { 'Authorization' => access_token(accessing_admin)}
        expect(json['error']).to eq('Resource not found')
      end
    end
  end
end
