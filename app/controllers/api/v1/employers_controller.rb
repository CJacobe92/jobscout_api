class Api::V1::EmployersController < ApplicationController
  include EmployerPermissions
  include MessageHelper
  before_action :load_employer, only: [:show, :update , :destroy]

  def index
    if administration_scope
      query = params[:query]
      page = params[:page] || 1

      if query.present?
        search_conditions = [
          'LOWER(company_name) LIKE :query OR
           LOWER(company_address) LIKE :query OR 
           LOWER(company_email) LIKE :query OR
           LOWER(company_phone) LIKE :query OR
           LOWER(company_poc_name) LIKE :query OR
           LOWER(company_poc_title) LIKE :query'
        ]

        where_conditions = search_conditions.join(' OR ')

        @employers = Employer.where(where_conditions, query: "%#{query}%").page(page).per(10)
      else
        @employers = Employer.where(tenant: params[:tenant_id]).page(page).per(10)
      end
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def create
    if administration_scope
      @employer = Employer.new(employer_params)
      
      if @employer.save
        render json: CREATED, status: :created
      else
        render json: UNPROCESSABLE_ENTITY, status: :unprocessable_entity
      end
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def show
    if administration_scope
      render 'show', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def update
    if administration_scope
      @current_employer.update(employer_params)
      render 'update', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def destroy
    if administration_scope
      @current_employer.destroy
      head :no_content
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  private

  def employer_params
    params.require(:employer).permit(:company_name, :company_address, :company_email, :company_phone, :company_poc_name, :company_poc_title, :tenant_id)
  end
  
  def load_employer
    begin
      @current_employer = Employer.includes(:jobs).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
