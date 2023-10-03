class Api::V1::OwnersController < ApplicationController
  include OwnerPermissions
  include GlobalPermissions
  include MessageHelper
  before_action :load_owner, only: [ :show, :update , :destroy ] 
  before_action :authenticate, except: [ :create ]

  def index
    if global_scope
      @owners = Owner.all
      render 'index', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def create 
    @owner = Owner.new(owner_params)
    
    if @owner.save
      render json: CREATED, status: :created
    else
      render json: UNPROCESSABLE_ENTITY, status: :unprocessable_entity
    end
  end

  def show
    if administration_scope || global_scope
      render 'show', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def update
    if administration_scope || global_scope
      @current_owner.update(owner_params)
      render 'update', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def destroy
    if global_scope
      if @current_owner.destroy
        head :no_content
      end
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  private

  def owner_params
    params.require(:owner).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation, :tenant_id)
  end
  
  def load_owner
    begin
      @current_owner = Owner.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
