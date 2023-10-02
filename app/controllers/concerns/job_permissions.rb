module JobPermissions
  extend ActiveSupport::Concern
    include GlobalPermissions

    def administration_scope
      return true if global_scope

      return allowed_roles.include?(@current_user.role)
    end

    def user_scope
      allowed_roles = %w[ employee employer owner ]

      return allowed_roles.include?(@current_user.role) && @current_employee.id == @current_user.id
    end
end