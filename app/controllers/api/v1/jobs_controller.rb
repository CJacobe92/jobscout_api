class Api::V1::JobsController < ApplicationController
  include GlobalPermissions
  include JobPermissions
  include MessageHelper
  before_action :load_job, except: [:index, :create]
  before_action :authenticate, except: [:show, :index]

  def index
    @jobs = Job.includes(:employer)
    render 'index', status: :ok
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
    params.require(:job).permit(:job_name, :job_description, :job_requirement, :job_headcount, :job_salary, :job_currency, :job_status, :job_location, :job_type, :deadline, :employer_id)
  end

  def load_job
    begin
      @current_job = Job.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
