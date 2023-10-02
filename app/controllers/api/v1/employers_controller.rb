class Api::V1::EmployersController < ApplicationController
  include EmployerPermissions
  include MessageHelper
  before_action :load_employer, only: [:show, :update , :destroy]

  def index
    if administration_scope
      @employers = Employer.all
      render 'index', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
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
    if user_scope || administration_scope
      render 'show', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def update
    if user_scope || administration_scope
      @current_employer.update(employer_params)
      render 'update', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def destroy
    if administration_scope
      @current_owner.destroy
      head :no_content
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  private

  def employer_params
    params.require(:employer).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
  end
  
  def load_employer
    begin
      @current_employer = Employer.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
