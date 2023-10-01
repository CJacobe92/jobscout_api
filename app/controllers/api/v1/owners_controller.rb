require './app/services/role_auth'

class Api::V1::OwnersController < ApplicationController
  include RoleAuth
  before_action :load_owner, only: [ :show, :update , :destroy ] 
  before_action :admin_only, only: [ :index, :destroy ]

  def index
    @owners = Owner.all
    render 'index', status: :ok
  end

  def create
    @owner = Owner.new(owner_params)
    
    if @owner.save
      render json: { message: 'Owner created'}, status: :created
    else
      render json: { error: 'Failed to create owner'}, status: :unprocessable_entity
    end
  end

  def show
    return unless @current_owner
    render 'show', status: :ok
  end

  def update
    return unless @current_owner.update(owner_params)
    render 'update', status: :ok
  end

  def destroy
    return unless @current_owner.destroy
    head :no_content
  end

  private

  def owner_params
    params.require(:owner).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
  end
  
  def load_owner
    @current_owner = Owner.find_by(id: params[:id])
  end
end
