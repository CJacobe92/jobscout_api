class Api::V1::JobsController < ApplicationController
  include GlobalPermissions
  include JobPermissions
  include MessageHelper
  before_action :load_job, except: [:index, :create, :tenant_index]
  before_action :authenticate, except: [:show, :index]

  def index
    page = params[:page] || 1
    query = params[:query]
    location = params[:location]

    if query.present? || location.present?

      search_conditions = [
      ' LOWER(job_name) LIKE :query OR
        LOWER(tags) LIKE :query OR
        LOWER(job_type) LIKE :query OR
        LOWER(job_status) LIKE :query OR
        LOWER(job_salary) LIKE :query OR
        LOWER(job_currency) LIKE :query OR
        LOWER(company_name) LIKE :query '
      ]
      
      where_conditions = search_conditions.join(' OR ')

      @jobs = Job.joins(:employer).includes(:employer)
                 .where(where_conditions, query: "%#{query}%")
                 .where('LOWER(job_location) LIKE :location', location: "%#{location}%")
                 .page(page).per(10)
    else
      @jobs = Job.joins(:employer).includes(:employer).page(page).per(10)
    end
    render 'index', status: :ok
  end

  def tenant_index

    page = params[:page] || 1
    tenant_id = params[:tenant]
    query = params[:query]
    location = params[:location]
    assignment = params[:assignment]

    if administration_scope || global_scope

      if query.present? || assignment.present? || location.present?
        search_conditions = [
          ' LOWER(job_name) LIKE :query OR
            LOWER(tags) LIKE :query OR
            LOWER(job_type) LIKE :query OR
            LOWER(job_status) LIKE :query OR
            LOWER(job_salary) LIKE :query OR
            LOWER(job_currency) LIKE :query OR
            LOWER(company_name) LIKE :query '
        ]

        where_conditions = search_conditions.join(' OR ')

        @jobs = Job.joins(:employer).includes(:employer)
                .where(employers: {tenant_id: tenant_id})
                .where(where_conditions, query: "%#{query}%")
                .where('LOWER(job_location) LIKE :location', location: "%#{location}%")
                .where("LOWER(assignment) LIKE :assignment", assignment: "%#{assignment}%")
                .page(page).per(10)   
      else
        @jobs = Job.includes(:employer).where(employers: { tenant_id: tenant_id }).page(page).per(10)
      end
    end
  end
  
  

  def create
    if administration_scope || global_scope
      @job = Job.new(job_params)

      if @job.save
        render json: CREATED, status: :created
      else
        render json: :UNPROCESSABLE_ENTITY, status: :unprocessable_entity
      end
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def show
    render 'show', status: :ok
  end

  def update
    if administration_scope || global_scope
      @current_job.update(job_params)
      render 'update', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def destroy
    if administration_scope || global_scope
      @current_job.destroy
      head :no_content
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  private

  def job_params
    params.require(:job).permit(:job_name, :job_description, :job_requirement, :job_headcount, :job_salary, :job_currency, :job_status, :job_location, :job_type, :deadline, :assignment, :employer_id)
  end

  def load_job
    begin
      @current_job = Job.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
