module RoleAuth

  # singular role permissions
  def admin_only
    render_unauthorized_error('admin') unless @current_user.role == 'admin'
  end

  def employee_only
    render_unauthorized_error('employee') unless @current_user.role == 'employee'
  end

  def owner_only
    render_unauthorized_error('owner') unless @current_user.role == 'owner'
  end

  def employer_only
    render_unauthorized_error('employer') unless @current_user.role == 'employer'
  end

  def employer_only
    render_unauthorized_error('applicant') unless @current_user.role == 'applicant'
  end

  # combined role permissions
  def admin_or_owner_only
    unless @current_user == 'admin' || @current_user.role == 'owner'
      render json: { error: 'Unauthorized resource access' }, status: :unauthorized
    end
  end

  private

  def render_unauthorized_error(role)
    render json: { error: "Unauthorized #{role} access" }, status: :unauthorized
  end
end