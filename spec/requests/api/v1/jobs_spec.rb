require 'rails_helper'

RSpec.describe "Api::V1::Jobs", type: :request do
  describe "GET /index" do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create(:tenant, owner_id: owner.id) }
    let!(:employer) { create(:employer, tenant_id: tenant.id) }
    let!(:existing_jobs) { create_list(:job, 10, employer_id: employer.id) }
    let!(:admin) { create(:admin) }

    context 'with correct authorization' do
      before do
        get '/api/v1/jobs', headers: { "Authorization" => access_token(admin) }
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct json data' do
        json.map do |data|
          expect(data.size).to eq(15)
        end
      end
    end

    context 'with incorrect authorization' do
      let!(:unauthorized_user) { create(:applicant)}

      before do
        get '/api/v1/jobs', headers: { 'Authorization' => access_token(unauthorized_user)}
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /create" do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create(:tenant, owner_id: owner.id) }
    let!(:employee) { create(:employee, tenant_id: tenant.id) }
    let!(:employer) { create(:employer, tenant_id: tenant.id) }
    let!(:admin) { create(:admin) }

    context 'with correct authorization' do
      it 'returns 201 status for owner' do
        params = { job: attributes_for(:job, employer_id: employer.id) }
        post '/api/v1/jobs', headers: { "Authorization" => access_token(owner) }, params: params

        expect(response).to have_http_status(:created)
      end

      it 'returns 201 status for employee' do
        params = { job: attributes_for(:job, employer_id: employer.id) }
        post '/api/v1/jobs', headers: { "Authorization" => access_token(employee) }, params: params

        expect(response).to have_http_status(:created)
      end

      it 'returns 201 status for admin' do
        params = { job: attributes_for(:job, employer_id: employer.id) }
        post '/api/v1/jobs', headers: { "Authorization" => access_token(admin) }, params: params

        expect(response).to have_http_status(:created)
      end

      it 'returns 422 status for incorrect parameters' do
        params = { job: {invalid_key: 'wrong_key'} }
        post '/api/v1/jobs', headers: { "Authorization" => access_token(admin) }, params: params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with incorrect authorization' do
      let!(:unauthorized_user) { create(:applicant)}

      before do
        params = { job: attributes_for(:job, employer_id: employer.id) }
        post '/api/v1/jobs', headers: { "Authorization" => access_token(unauthorized_user) }, params: params
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /show' do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create(:tenant, owner_id: owner.id) }
    let!(:employer) { create(:employer, tenant_id: tenant.id) }
    let!(:job) { create(:job, employer_id: employer.id) }
    
    it 'returns 201 status for owner' do
      get "/api/v1/jobs/#{job.id}"
    end
  end

  describe "PATCH /update" do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create(:tenant, owner_id: owner.id) }
    let!(:employee) { create(:employee, tenant_id: tenant.id) }
    let!(:employer) { create(:employer, tenant_id: tenant.id) }
    let!(:job) { create(:job, employer_id: employer.id) }
    let!(:admin) { create(:admin) }

    context 'with correct authorization' do
      it 'returns 201 status for owner' do
        params = { job: attributes_for(:job, employer_id: employer.id) }
        patch "/api/v1/jobs/#{job.id}", headers: { "Authorization" => access_token(owner) }, params: params

        expect(response).to have_http_status(:ok)
      end

      it 'returns 201 status for employee' do
        params = { job: attributes_for(:job, employer_id: employer.id) }
        patch "/api/v1/jobs/#{job.id}", headers: { "Authorization" => access_token(employee) }, params: params

        expect(response).to have_http_status(:ok)
      end

      it 'returns 201 status for admin' do
        params = { job: attributes_for(:job, employer_id: employer.id) }
        patch "/api/v1/jobs/#{job.id}", headers: { "Authorization" => access_token(admin) }, params: params

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with incorrect authorization' do
      let!(:unauthorized_user) { create(:applicant)}

      before do
        params = { job: attributes_for(:job, employer_id: employer.id) }
        patch "/api/v1/jobs/#{job.id}", headers: { "Authorization" => access_token(unauthorized_user) }, params: params
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
    let!(:employer) { create(:employer, tenant_id: tenant.id) }
    let!(:job) { create(:job, employer_id: employer.id) }
    let!(:admin) { create(:admin) }

    context 'with correct authorization' do
      it 'returns 204 status for owner' do
        delete "/api/v1/jobs/#{job.id}", headers: { "Authorization" => access_token(owner) }

        expect(response).to have_http_status(:no_content)
      end

      it 'returns 204 status for owner' do
        delete "/api/v1/jobs/#{job.id}", headers: { "Authorization" => access_token(employee) }

        expect(response).to have_http_status(:no_content)
      end

      it 'returns 204 status for admin' do
        delete "/api/v1/jobs/#{job.id}", headers: { "Authorization" => access_token(admin) }

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with incorrect authorization' do
      let!(:unauthorized_user) { create(:applicant)}

      before do
        delete "/api/v1/jobs/#{job.id}", headers: { "Authorization" => access_token(unauthorized_user) }
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'load_employee' do
    let!(:owner) { create(:owner) }

    it 'returns not found when resource does not exist' do
      get "/api/v1/jobs/99999", headers: { 'Authorization' => access_token(owner)}
      expect(json['error']).to eq('Resource not found')
    end
  end
end
