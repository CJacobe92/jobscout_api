require 'rails_helper'

RSpec.describe "Api::V1::Applicants", type: :request do
  describe "GET /index" do
    let!(:existing_applicants) { create_list(:applicant, 10) }
    let!(:accessing_admin) { create(:admin) }

    context 'with correct authorization' do
      before do
        get '/api/v1/applicants', headers: { 'Authorization' => access_token(accessing_admin)}
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

      context 'with incorrect authorization' do

        let!(:unauthorized_user) { create(:applicant)}
        let!(:admin) { create(:admin) }
  
  
        before do
          get "/api/v1/applicants", headers: { 'Authorization' => access_token(unauthorized_user)}
        end
  
        it 'returns 401 status' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe "POST /create" do

    context 'when applicants sign up' do
      before do
        params = { applicant: attributes_for(:applicant) }
        post '/api/v1/applicants', params: params
      end

      it 'with correct parameters returns 201 status' do
        expect(response).to have_http_status(:created)
      end

      it 'with incorrect parameters returns 422 status' do
        incorrect_params = { applicant: { incorrect_key: 'incorrect_params' } }
        post '/api/v1/applicants', params: incorrect_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /show" do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create(:tenant, owner_id: owner.id) }
    let!(:employee) { create(:employee, tenant_id: tenant.id) }
    let!(:applicant) { create(:applicant) }
    let!(:admin) { create(:admin) }
   
    context 'with correct authorization' do
      it 'returns 200 status for owner' do
        get "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(owner)}

        expect(response).to have_http_status(:ok)
      end

      it 'returns 200 status for admin' do
        get "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(admin)}

        expect(response).to have_http_status(:ok)
      end

      it 'returns 200 status for applicant' do
        get "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(applicant)}
        expect(response).to have_http_status(:ok)
      end

      it 'returns 200 status for employee' do
        get "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(employee)}
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct response body' do

        get "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(applicant)}

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
      let!(:owner) { create(:owner) }
      let!(:tenant) { create(:tenant, owner_id: owner.id) }
      let!(:applicant) { create(:applicant) }
      let!(:unauthorized_user) { create(:applicant) }
      
      before do
        get "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(unauthorized_user)}
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /update" do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create(:tenant, owner_id: owner.id) }
    let!(:employee) { create(:employee, tenant_id: tenant.id) }
    let!(:applicant) { create(:applicant) }
    let!(:admin) { create(:admin) }
   
    context 'with correct authorizzation' do
      it 'updated with the correct data and returns 200 status for owner' do
        params = {applicant: { firstname: 'root'} }
        patch "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(owner) }, params: params

        expect(response).to have_http_status(:ok)
        expect(json['firstname']).to eq('root')
      end

      it 'updated with the correct data and returns 200 status for employee' do
        params = {applicant: { firstname: 'root'} }
        patch "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(employee) }, params: params

        expect(response).to have_http_status(:ok)
        expect(json['firstname']).to eq('root')
      end

      
      it 'updated with the correct data and returns 200 status for admin' do
        params = {applicant: { firstname: 'root'} }
        patch "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(admin) }, params: params

        expect(response).to have_http_status(:ok)
        expect(json['firstname']).to eq('root')
      end

      
      it 'updated with the correct data and returns 200 status for applicant' do
        params = {applicant: { firstname: 'root'} }
        patch "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(applicant) }, params: params

        expect(response).to have_http_status(:ok)
        expect(json['firstname']).to eq('root')
      end

      it 'returns the correct response body' do

        params = {applicant: { firstname: 'root'} }
        patch "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(applicant) }, params: params

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
      let!(:owner) { create(:owner) }
      let!(:tenant) { create(:tenant, owner_id: owner.id) }
      let!(:applicant) { create(:applicant) }
      let!(:unauthorized_user) { create(:applicant) }
      
      before do
        params = {applicant: { firstname: 'root'} }
        patch "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(unauthorized_user)}, params: params
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create(:tenant, owner_id: owner.id) }
    let!(:employee) { create(:employee, tenant_id: tenant.id) }
    let!(:applicant) { create(:applicant) }
    let!(:admin) { create(:admin) }
    
    context 'with correct authorization' do
      it 'deletes applicant and returns 204 status for owner' do
        delete "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(owner) }

        expect(response).to have_http_status(:no_content)
      end

      it 'deletes applicant and returns 204 status for employee' do
        delete "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(employee) }

        expect(response).to have_http_status(:no_content)
      end

      it 'deletes applicant and returns 204 status for admin' do
        delete "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(admin) }

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with incorrect authorization' do
      let!(:owner) { create(:owner) }
      let!(:tenant) { create(:tenant, owner_id: owner.id) }
      let!(:applicant) { create(:applicant) }
      let!(:unauthorized_user) { create(:applicant) }
      
      before do
        delete "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(unauthorized_user)}
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'load_applicant' do
    let!(:applicant) { create(:applicant) }

    it 'returns not found when resource does not exist' do
      get "/api/v1/applicants/99999", headers: { 'Authorization' => access_token(applicant)}
      expect(json['error']).to eq('Resource not found')
    end
  end
end
