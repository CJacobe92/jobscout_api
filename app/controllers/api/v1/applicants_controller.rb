
class Api::V1::ApplicantsController < ApplicationController
  include ApplicantPermissions
  include MessageHelper

  before_action :authenticate, except: [ :create ]
  before_action :load_applicant, only: [:show, :update, :destroy]

  def index
    if administration_scope
      @applicants = Applicant.all
      render 'index', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def create
    @applicant = Applicant.new(applicant_params)
    
    if @applicant.save
      render json: CREATED, status: :created
    else
      render json: UNPROCESSABLE_ENTITY, status: :unprocessable_entity
    end
  end

  def show
    if self_read_scope || administration_scope
      render 'show', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def update
    if self_read_scope || administration_scope
      @current_applicant.update(applicant_params)
      render 'update', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def destroy
    if administration_scope
       @current_applicant.destroy
       head :no_content
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  private

  def applicant_params
    params.require(:applicant).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
  end
  
  def load_applicant
    @current_applicant = Applicant.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Resource not found' }, status: :not_found
  end
end

