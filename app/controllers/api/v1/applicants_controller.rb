class Api::V1::ApplicantsController < ApplicationController
  before_action :load_applicant, only: [:show, :update , :destroy]

  def index
    @applicants = Applicant.all
    render 'index', status: :ok
  end

  def create
    @applicant = Applicant.new(applicant_params)
    
    if @applicant.save
      render json: { message: 'Applicant created'}, status: :created
    else
      render json: { error: 'Failed to create applicant'}, status: :unprocessable_entity
    end
  end

  def show
    return unless @current_applicant
    render 'show', status: :ok
  end

  def update
    return unless @current_applicant.update(applicant_params)
    render 'update', status: :ok
  end

  def destroy
    return unless @current_applicant.destroy
    head :no_content
  end

  private

  def applicant_params
    params.require(:applicant).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
  end
  
  def load_applicant
    @current_applicant = Applicant.find_by(id: params[:id])
  end
end
