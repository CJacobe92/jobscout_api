require 'rails_helper'

RSpec.describe "Api::V1::Employers", type: :request do
  describe "GET /index" do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create(:tenant, owner_id: owner.id) }
    let!(:existing_employer) { create_list(:employer, 10, tenant_id: tenant.id) }
    let!(:accessing_admin) { create(:admin) }

    context 'with correct authorization' do
      before do
        get '/api/v1/employers', headers: { 'Authorization' => access_token(accessing_admin)}
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

  # describe "POST /create" do

  #   let!(:owner) { create(:owner) }
  #   let!(:tenant) { create(:tenant, owner_id: owner.id) }

  #   context 'when applicants sign up' do
  #     before do
  #       params = { employee: attributes_for(:employee, tenant_id: tenant.id) }
  #       post '/api/v1/employees', headers: { 'Authorization' => access_token(owner) }, params: params
  #     end

  #     it 'with correct parameters returns 201 status' do
  #       expect(response).to have_http_status(:created)
  #     end

  #     it 'with incorrect parameters returns 422 status' do
  #       incorrect_params = { employee: { incorrect_key: 'incorrect_params' } }
  #       post '/api/v1/employees', headers: { 'Authorization' => access_token(owner) }, params: incorrect_params
  #       expect(response).to have_http_status(:unprocessable_entity)
  #     end
  #   end
  # end

  # describe "GET /show" do
  #   let!(:owner) { create(:owner) }
  #   let!(:tenant) { create(:tenant, owner_id: owner.id) }
  #   let!(:accessing_employee) { create(:employee, tenant_id: tenant.id)}
  #   let!(:accessing_admin) { create(:admin) }
   

  #   it 'returns 200 status for owner' do
  #     get "/api/v1/employees/#{accessing_employee.id}", headers: { 'Authorization' => access_token(owner)}

  #     expect(response).to have_http_status(:ok)
  #   end

  #   it 'returns 200 status for admin' do
  #     get "/api/v1/employees/#{accessing_employee.id}", headers: { 'Authorization' => access_token(accessing_admin)}

  #     expect(response).to have_http_status(:ok)
  #   end

  #   it 'returns 200 status for employee' do
  #     get "/api/v1/employees/#{accessing_employee.id}", headers: { 'Authorization' => access_token(accessing_employee)}

  #     expect(response).to have_http_status(:ok)
  #   end

  #   it 'returns the correct response body' do

  #     get "/api/v1/employees/#{accessing_employee.id}", headers: { 'Authorization' => access_token(accessing_employee)}

  #     restricted_parameters = %w[
  #       password_digest
  #       access_token
  #       refresh_token
  #       reset_token
  #       otp_secret_key
  #       enabled
  #       otp_enabled
  #       otp_required
  #       activation_token
  #     ]

  #     expect(json).not_to include(restricted_parameters)
  #   end

  #   it 'returns not found when resource does not exist' do
  #     get "/api/v1/employees/99999", headers: { 'Authorization' => access_token(accessing_employee)}
  #     expect(json['error']).to eq('Resource not found')
  #   end
  # end

  # describe "GET /show" do
  #   let!(:owner) { create(:owner) }
  #   let!(:tenant) { create(:tenant, owner_id: owner.id) }
  #   let!(:accessing_employee) { create(:employee, tenant_id: tenant.id)}
  #   let!(:accessing_admin) { create(:admin) }
   

  #   it 'returns 200 status for owner' do
  #     get "/api/v1/employees/#{accessing_employee.id}", headers: { 'Authorization' => access_token(owner)}

  #     expect(response).to have_http_status(:ok)
  #   end

  #   it 'returns 200 status for admin' do
  #     get "/api/v1/employees/#{accessing_employee.id}", headers: { 'Authorization' => access_token(accessing_admin)}

  #     expect(response).to have_http_status(:ok)
  #   end

  #   it 'returns 200 status for employee' do
  #     get "/api/v1/employees/#{accessing_employee.id}", headers: { 'Authorization' => access_token(accessing_employee)}

  #     expect(response).to have_http_status(:ok)
  #   end

  #   it 'returns the correct response body' do

  #     get "/api/v1/employees/#{accessing_employee.id}", headers: { 'Authorization' => access_token(accessing_employee)}

  #     restricted_parameters = %w[
  #       password_digest
  #       access_token
  #       refresh_token
  #       reset_token
  #       otp_secret_key
  #       enabled
  #       otp_enabled
  #       otp_required
  #       activation_token
  #     ]

  #     expect(json).not_to include(restricted_parameters)
  #   end

  #   it 'returns not found when resource does not exist' do
  #     get "/api/v1/employees/99999", headers: { 'Authorization' => access_token(accessing_employee)}
  #     expect(json['error']).to eq('Resource not found')
  #   end
  # end

  # describe "DELETE /destroy" do
  #   let!(:owner) { create(:owner) }
  #   let!(:tenant) { create(:tenant, owner_id: owner.id) }
  #   let!(:employee) { create(:employee, tenant_id: tenant.id)}

  #   let!(:accessing_admin) { create(:admin) }
   

  #   it 'returns 204 status for owner' do
  #     delete "/api/v1/employees/#{employee.id}", headers: { 'Authorization' => access_token(owner)}

  #     expect(response).to have_http_status(:no_content)
  #   end

  #   it 'returns 204 status for admin' do
  #     delete "/api/v1/employees/#{employee.id}", headers: { 'Authorization' => access_token(accessing_admin)}

  #     expect(response).to have_http_status(:no_content)
  #   end

  #   it 'returns not found when resource does not exist' do
  #     delete "/api/v1/employees/99999", headers: { 'Authorization' => access_token(owner)}
  #     expect(json['error']).to eq('Resource not found')
  #   end
  # end
end
