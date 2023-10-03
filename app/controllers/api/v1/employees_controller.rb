class Api::V1::EmployeesController < ApplicationController
  include EmployeePermissions
  include MessageHelper
  before_action :load_employee, only: [:show, :update , :destroy]

  def index
    if administration_scope
      @employees = Employee.all
      render 'index', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def create
    if administration_scope
      @employee = Employee.new(employee_params)
      
      if @employee.save
        render json: CREATED, status: :created
      else
        render json: UNPROCESSABLE_ENTITY, status: :unprocessable_entity
      end
    else
      render json: UNAUTHORIZED, status: :unauthorized
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
      @current_employee.update(employee_params)
      render 'update', status: :ok
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  def destroy
    if administration_scope
      @current_employee.destroy
      head :no_content
    else
      render json: UNAUTHORIZED, status: :unauthorized
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation, :tenant_id)
  end
  
  def load_employee
    begin
      @current_employee = Employee.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
