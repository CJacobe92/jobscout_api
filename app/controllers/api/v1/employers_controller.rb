class Api::V1::EmployersController < ApplicationController
  before_action :load_employer, only: [:show, :update , :destroy]

  def index
    @employers = Employer.all
    render 'index', status: :ok
  end

  def create
    @employer = Employer.new(employer_params)
    
    if @employer.save
      render json: { message: 'Employer created'}, status: :created
    else
      render json: { error: 'Failed to create employer'}, status: :unprocessable_entity
    end
  end

  def show
    return unless @current_employer
    render 'show', status: :ok
  end

  def update
    return unless @current_employer.update(employer_params)
    render 'update', status: :ok
  end

  def destroy
    return unless @current_employer.destroy
    head :no_content
  end

  private

  def employer_params
    params.require(:employer).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
  end
  
  def load_employer
    @current_employer = Employer.find_by(id: params[:id])
  end
end
