require './app/services/role_auth'

class Api::V1::AdminsController < ApplicationController
  include RoleAuth
  before_action :authenticate
  before_action :admin_only
  before_action :load_admin, only: [ :show, :update , :destroy ]
 
  def index
    @admins = Admin.all
    render 'index', status: :ok
  end

  def create
    @admin = Admin.new(admin_params)
    
    if @admin.save
      render json: { message: 'Admin created'}, status: :created
    else
      render json: { error: 'Failed to create admin'}, status: :unprocessable_entity
    end
  end

  def show
    return unless @current_admin
    render 'show', status: :ok
  end

  def update
    return unless @current_admin.update(admin_params)
    render 'update', status: :ok
  end

  def destroy
    return unless @current_admin.destroy
    head :no_content
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
