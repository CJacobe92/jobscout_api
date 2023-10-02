class Api::V1::TenantsController < ApplicationController
  before_action :load_tenant, except: [ :index, :create ]

  def index
    @tenants = Tenant.all
    render 'index', status: :ok
  end

  def create
    @tenant = Tenant.create

    if @tenant.save
      render json: {message: 'Tenant created'}, status: :created
    else
      render json: {error: 'Failed to create tenant'}, status: :unprocessable_entiy
    end
  end

  def show
    return unless @current_tenant
    render 'show', status: :ok
  end

  def update
    return unless @current_tenant.update(tenant_params)
    render 'update', status: :ok
  end

  def destroy
    return unless @current_tenant.destroy
    head :no_content
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
