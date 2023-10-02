module EmployerPermissions
  extend ActiveSupport::Concern
    include GlobalPermissions

    def administration_scope
      return true if global_scope

      allowed_roles = %w[ owner employee ]

      return allowed_roles.include?(@current_user.role)
    end

    def user_scope
      allowed_roles = %w[ employer ]

      return allowed_roles.include?(@current_user.role) && @current_employer.id == @current_user.id
    end
end