require 'rails_helper'

RSpec.describe "Api::V1::Tenants", type: :request do
  describe "GET /index" do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create_list(:tenant, 10, owner_id: owner.id) }
    let!(:admin) { create(:admin) }

    before do
      get '/api/v1/tenants', headers: {"Authorization" =>  access_token(admin) }
    end

    it 'returns 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns correct json data' do
      json.map do |data|
        expect(data.size).to eq(13)
      end
    end

    context 'with incorrect authorization' do

      let!(:unauthorized_user) { create(:applicant) }

      before do
        get '/api/v1/tenants', headers: {"Authorization" =>  access_token(unauthorized_user) }
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /create' do
    let!(:owner) { create(:owner) }
    let!(:admin) { create(:admin) }

    context 'with correct authorization' do
      it 'with correct parameters returns 201 status for owner' do
        params = {tenant: attributes_for( :tenant, owner_id: owner.id) }
        post '/api/v1/tenants', headers: { "Authorization" => access_token(owner) }, params: params
        
        expect(response).to have_http_status(:created)
      end
  
      it 'with correct parameters returns 201 status for owner' do
        params = {tenant: attributes_for( :tenant, owner_id: owner.id) }
        post '/api/v1/tenants', headers: { "Authorization" => access_token(admin) }, params: params
        
        expect(response).to have_http_status(:created)
      end

      it 'with incorrect parameters returns 422 status for owner' do
        params = { tenant: {bad_params: 'bad_params'} }
        post '/api/v1/tenants', headers: { "Authorization" => access_token(admin) }, params: params
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
   
    context 'with incorrect authorization' do

      let!(:unauthorized_user) { create(:applicant) }

      before do
        post '/api/v1/tenants', headers: {"Authorization" =>  access_token(unauthorized_user) }
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  
  describe 'GET /show' do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create(:tenant, owner_id: owner.id) }
    let!(:admin) { create(:admin) }

    context 'with correct authorization' do
      it 'returns 201 status for owner' do
        get "/api/v1/tenants/#{tenant.id}", headers: { "Authorization" => access_token(owner) }
        
        expect(response).to have_http_status(:ok)
      end
  
      it 'returns 201 status for admin' do
        get "/api/v1/tenants/#{tenant.id}", headers: { "Authorization" => access_token(admin) }

        expect(response).to have_http_status(:ok)
      end
    end
   
    context 'with incorrect authorization' do

      let!(:unauthorized_user) { create(:applicant) }

      before do
        get "/api/v1/tenants/#{tenant.id}", headers: { "Authorization" => access_token(unauthorized_user) }
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /update' do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create(:tenant, owner_id: owner.id) }
    let!(:admin) { create(:admin) }

    context 'with correct authorization' do
      it 'returns 201 status for owner' do
        params = {tenant: attributes_for( :tenant, owner_id: owner.id) }
        patch "/api/v1/tenants/#{tenant.id}", headers: { "Authorization" => access_token(owner) }, params: params
        
        expect(response).to have_http_status(:ok)
      end
  
      it 'returns 201 status for admin' do
        params = {tenant: attributes_for( :tenant, owner_id: owner.id) }
        patch "/api/v1/tenants/#{tenant.id}", headers: { "Authorization" => access_token(admin) }, params: params

        expect(response).to have_http_status(:ok)
      end
    end
   
    context 'with incorrect authorization' do

      let!(:unauthorized_user) { create(:applicant) }

      before do
        patch "/api/v1/tenants/#{tenant.id}", headers: { "Authorization" => access_token(unauthorized_user) }
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:owner) { create(:owner) }
    let!(:tenant) { create(:tenant, owner_id: owner.id) }
    let!(:admin) { create(:admin) }

    context 'with correct authorization' do
      it 'returns 201 status for admin' do
        delete "/api/v1/tenants/#{tenant.id}", headers: { "Authorization" => access_token(admin) }

        expect(response).to have_http_status(:no_content)
      end
    end
   
    context 'with incorrect authorization' do

      let!(:unauthorized_user) { create(:applicant) }

      before do
        delete "/api/v1/tenants/#{tenant.id}", headers: { "Authorization" => access_token(unauthorized_user) }
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'load_tenant' do
    let!(:owner) { create(:owner) }

    it 'returns not found when resource does not exist' do
      get "/api/v1/tenants/99999", headers: { 'Authorization' => access_token(owner)}
      expect(json['error']).to eq('Resource not found')
    end
  end
end
