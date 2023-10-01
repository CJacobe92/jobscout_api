class Api::V1::EmployeesController < ApplicationController
  before_action :load_employee, only: [:show, :update , :destroy]

  def index
    @employees = Employee.all
    render 'index', status: :ok
  end

  def create
    @employee = Employee.new(employee_params)
    
    if @employee.save
      render json: { message: 'Employee created'}, status: :created
    else
      render json: { error: 'Failed to create employee'}, status: :unprocessable_entity
    end
  end

  def show
    return unless @current_employee
    render 'show', status: :ok
  end

  def update
    return unless @current_employee.update(employee_params)
    render 'update', status: :ok
  end

  def destroy
    return unless @current_employee.destroy
    head :no_content
  end

  private

  def employee_params
    params.require(:employee).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
  end
  
  def load_employee
    @current_employee = Employee.find_by(id: params[:id])
  end
end
