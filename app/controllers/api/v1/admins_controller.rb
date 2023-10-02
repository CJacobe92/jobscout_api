class Api::V1::AdminsController < ApplicationController
  include GlobalPermissions
  include MessageHelper
  before_action :authenticate
  before_action :load_admin, only: [ :show, :update , :destroy ]
 
  def index
    if global_scope
      @admins = Admin.all
      render 'index', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def create
    if global_scope
      @admin = Admin.new(admin_params)
      
      if @admin.save
        render json: CREATED , status: :created
      else
        render json: UNPROCESSABLE_ENTITY, status: :unprocessable_entity
      end
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def show
    if global_scope
      render 'show', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def update
    if global_scope
        @current_admin.update(admin_params)
        render 'update', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end  
  end

  def destroy
    if global_scope
      @current_admin.destroy
      head :no_content
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end  
  end

  private

  def admin_params
    params.require(:admin).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
  end
  
  def load_admin
    begin
      @current_admin = Admin.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
