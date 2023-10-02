class Api::V1::JobsController < ApplicationController
  include JobPermissions
  include MessageHelper
  before_action :load_job, except: [:index, :create]
  before_action :authenticate, except: [:show]

  def index
    if administration_scope
      @jobs = Job.all
      render json: 'index', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def create
    if administration_scope || user_scope
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
    if administration_scope || user_scope
      render 'show', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def update
    if administration_scope || user_scope
      @current_job.update(job_params)
      render 'update', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def destroy
    if administration_scope || user_scope
      @current_job.destroy
      head :no_content
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  private

  def job_params
    params.require(:job).permit(:job_name, :job_description, :job_requirements, :job_headcount, :job_salary, :job_currency, :job_status, :job_location, :job_type, :deadline)
  end

  def load_job
    @current_job = Job.find_by(id: params[:id])
  end
end
