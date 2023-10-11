class Api::V1::JobApplicationsController < ApplicationController
  include JobApplicationsPermissions
  include MessageHelper
  before_action :authenticate
  before_action :load_job_application, only: [:show, :update, :destroy]

  def index

    if read_scope || global_scope
      page = params[:page] || 1

      if params[:applicant_id].present?
        applicant_index(page)
      elsif params[:job_id].present?
        job_applicants_index(page)
      elsif params[:query].present? || params[:location].present?
        query_index(page)
      end
    end
  end

  def applicant_index(page)
    applicant_id = params[:applicant_id]

    if applicant_id.present?
      @job_applications = JobApplication.where(applicant_id: applicant_id).page(page).per(10)
      render json: {data: @job_applications }, status: :ok
    end
  end
  
  def job_applicants_index(page)
    job_id = params[:job_id]

    if job_id.present?
      @job_applications = JobApplication.where(job_id: job_id).page(page).per(10)
      render json: {data: @job_applications}, status: :ok
    end
  end

  def query_index(page)
    query = params[:query]
    location = params[:location]

    search_params = ['
        firstname ILIKE :query OR
        lastname ILIKE :query OR
        email ILIKE :query OR
        company_name ILIKE :query OR
        job_name ILIKE :query OR
        job_type ILIKE :query OR
        job_location ILIKE :query OR
        status ILIKE :query
      ']

      where_conditions = search_params.join(' OR ')

      @job_applications = JobApplication.where(where_conditions, query: "%#{query}%").page(page).per(10)

      render json: {data: @job_applications}, status: :ok
  end

  def create
  end

  def show
    if self_read_scope || administration_scope
      render json: {data: @current_job_application}, status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def update
    if administration_scope
      @current_job_application.update(job_application_params)
      render 'update', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def update
    if administration_scope || self.read_scope
      @current_job_application.destroy
      head :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def job_application_params
    params(:job_application).require(:firstname, :lastname, :email, :company, :job_name, :job_location, :job_status, :status, :job_id, :applicant_id)
  end

  def load_job_application
    begin
      @current_job_application = JobApplication.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
