class Api::V1::TenantsController < ApplicationController
  include TenantPermissions
  include MessageHelper
  before_action :load_tenant, except: [ :index, :create ]

  def index
    if administration_scope
      @tenants = Tenant.all
      render 'index', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def create
    @tenant = Tenant.create(tenant_params)

    if @tenant.save
      render json: CREATED, status: :created
    else
      render json: UNPROCESSABLE_ENTITY, status: :unprocessable_entiy
    end
  end

  def show
    if user_scope || administration_scope
      render 'show', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def update
    if user_scope || administration_scope
      if @current_tenant.update(tenant_params)
        render 'update', status: :ok
      else
        render json: UNPROCESSABLE_ENTITY, status: :unprocessable_entity
      end
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def destroy
    if administration_scope
      if @current_tenant.destroy
        head :no_content
      else
        render json: DELETION_FAILED, status: :unprocessable_entity
      end
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  private

  def tenant_params
    params.require(:tenant).permit(:company_name, :company_owner, :company_address, :company_email, :license, :contact_number, :subscription, :subdomain, :activated, :tenant_id)
  end

  def load_tenant
    begin
      @current_tenant = Tenant.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
