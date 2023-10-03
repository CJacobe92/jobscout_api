require 'rails_helper'

RSpec.describe "Api::V1::Owners", type: :request do
  describe "GET /index" do
    let!(:tenant) { create(:tenant) }
    let!(:owner) { create_list(:owner, 10, tenant_id: tenant.id) }
    let!(:admin) { create(:admin) }

    context 'with correct authorization' do
      before do
        get '/api/v1/owners', headers: { 'Authorization' => access_token(admin)}
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

    context 'with incorrect authorization' do

      let!(:unauthorized_user) { create(:applicant)}

      before do
        get "/api/v1/owners", headers: { 'Authorization' => access_token(unauthorized_user)}
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /create" do
    let!(:tenant) { create(:tenant) }

    it 'with correct parameters returns 201 status' do
      params = { owner: attributes_for(:owner, tenant_id: tenant.id) }
      post '/api/v1/owners', params: params

      expect(response).to have_http_status(:created)
    end

    it 'with incorrect parameters returns 422 status' do
      params = { owner: { invalid_key: 'wrong_params' } }
      post '/api/v1/owners', params: params

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /show" do
    let!(:tenant) { create(:tenant) }
    let!(:owner) { create(:owner, tenant_id: tenant.id) }
    let!(:admin) { create(:admin) }
   
    context 'with correct authorization' do
      it 'returns 200 status for owner' do
        get "/api/v1/owners/#{owner.id}", headers: { 'Authorization' => access_token(owner)}

        expect(response).to have_http_status(:ok)
      end

      it 'returns 200 status for admin' do
        get "/api/v1/owners/#{owner.id}", headers: { 'Authorization' => access_token(admin)}

        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct response body' do

        get "/api/v1/owners/#{owner.id}", headers: { 'Authorization' => access_token(owner)}

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
    end

    context 'with incorrect authorization' do
      let!(:unauthorized_user) { create(:applicant)}

      before do
        get "/api/v1/owners/#{owner.id}", headers: { 'Authorization' => access_token(unauthorized_user)}
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /update" do
    let!(:tenant) { create(:tenant) }
    let!(:owner) { create(:owner, tenant_id: tenant.id) }
    let!(:admin) { create(:admin) }
   
    context 'with correct authorization' do
      it 'returns 200 status for owner' do
        params = { owner: attributes_for(:owner) }
        patch "/api/v1/owners/#{owner.id}", headers: { 'Authorization' => access_token(owner)}, params: params

        expect(response).to have_http_status(:ok)
      end

      it 'returns 200 status for admin' do
        params = { owner: attributes_for(:owner) }
        patch "/api/v1/owners/#{owner.id}", headers: { 'Authorization' => access_token(admin)}, params: params

        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct response body' do

        params = { owner: attributes_for(:owner) }
        patch "/api/v1/owners/#{owner.id}", headers: { 'Authorization' => access_token(admin)}, params: params


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
    end

    context 'with incorrect authorization' do
      let!(:unauthorized_user) { create(:applicant)}

      before do
        params = { owner: attributes_for(:owner) }
        patch "/api/v1/owners/#{owner.id}", headers: { 'Authorization' => access_token(unauthorized_user) }, params: params
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:tenant) { create(:tenant) }
    let!(:owner) { create(:owner, tenant_id: tenant.id) }
    let!(:admin) { create(:admin) }
   
    context 'with correct authorization' do
      it 'returns 200 status for admin' do
        delete "/api/v1/owners/#{owner.id}", headers: { 'Authorization' => access_token(admin)}

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with incorrect authorization' do
      let!(:unauthorized_user) { create(:applicant)}

      before do
        delete "/api/v1/owners/#{owner.id}", headers: { 'Authorization' => access_token(unauthorized_user) }
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'load_owner' do
    let!(:tenant) { create(:tenant) }
    let!(:owner) { create(:owner, tenant_id: tenant.id) }

    it 'returns not found when resource does not exist' do
      get "/api/v1/owners/99999", headers: { 'Authorization' => access_token(owner)}
      expect(json['error']).to eq('Resource not found')
    end
  end
end
