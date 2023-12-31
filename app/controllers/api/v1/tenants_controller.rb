class Api::V1::TenantsController < ApplicationController
  include TenantPermissions
  include GlobalPermissions
  include MessageHelper
  before_action :load_tenant, except: [ :index, :create]
  before_action :authenticate, except: [:create]

  def index
    if global_scope
      @tenants = Tenant.all
      render 'index', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def create
    @tenant = Tenant.new(tenant_params)

    if @tenant.save
      render json: CREATED, status: :created
    else
      render json: UNPROCESSABLE_ENTITY, status: :unprocessable_entity
    end
  end

  def show
    if self_read_scope || global_scope
      render 'show', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def update
    if self_read_scope || global_scope
      @current_tenant.update(tenant_params)
      render 'update', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def destroy
    if global_scope
      @current_tenant.destroy
      head :no_content
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  private

  def tenant_params
    params.require(:tenant).permit(:company_name, :principal, :company_address, :company_email, :license, :contact_number, :subscription, :subdomain, :activated)
  end

  def load_tenant
    begin
      @current_tenant = Tenant.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
