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
    let!(:accessing_applicant) { create(:applicant)}

    context 'with correct authorization' do
      before do
        get "/api/v1/applicants/#{accessing_applicant.id}", headers: { 'Authorization' => access_token(accessing_applicant)}
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

      context 'with correct authorization but unowned resource' do

        let!(:unauthorized_user) { create(:applicant)}
        let!(:applicant) { create(:applicant) }
  
  
        before do
          get "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(unauthorized_user)}
        end
  
        it 'returns 401 status' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe "PATCH /update" do
    let!(:applicant) { create(:applicant)}

    context 'with correct authorization' do
      before do
        params = { applicant: { firstname: 'root' } }
        patch "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(applicant)}, params: params
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct response body' do
        restricted_parameters = %w[ password_digest access_token refresh_token reset_token otp_secret_key ]

        expect(json).not_to include(restricted_parameters)
        expect(json['firstname']).to include('root')
      end

      context 'with correct authorization but unowned resource' do

        let!(:unauthorized_user) { create(:applicant)}
        let!(:applicant) { create(:applicant) }
  
  
        before do
          params = { applicant: { firstname: 'root' } }
          patch "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(unauthorized_user)}, params: params
        end
  
        it 'returns 401 status' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:accessing_admin) { create(:admin) }
    let!(:terminated_applicant) { create(:applicant) }


    context 'with correct authorization' do
      before do
        delete "/api/v1/applicants/#{terminated_applicant.id}", headers: { 'Authorization' => access_token(accessing_admin)}
      end

      it 'returns no content' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with incorrect authorization' do

      let!(:unauthorized_user) { create(:applicant)}
      let!(:applicant) { create(:applicant) }


      before do
        params = { applicant: { firstname: 'root' } }
        delete "/api/v1/applicants/#{applicant.id}", headers: { 'Authorization' => access_token(unauthorized_user)}, params: params
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
