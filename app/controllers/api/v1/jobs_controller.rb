class Api::V1::JobsController < ApplicationController
  before_action :load_job, except: [:index, :create]

  def index
    @jobs = Job.all
    render json: 'index', status: :ok
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      render json: {message: 'Job created'}, status: :created
    else
      render json: {error: 'Failed to create job'}, status: :unprocessable_entity
    end
  end

  def show
    return unless @current_job
    render 'show', status: :ok
  end

  def update
    return unless @current_job.update(job_params)
    render 'update', status: :ok
  end

  def destroy
    return unless @current_job.destroy
    head :no_content
  end

  private

  def job_params
    params.require(:job).permit(:job_name, :job_description, :job_requirements, :job_headcount, :job_salary, :job_currency, :job_status, :job_location, :job_type, :deadline)
  end

  def load_job
    @current_job = Job.find_by(id: params[:id])
  end
end
