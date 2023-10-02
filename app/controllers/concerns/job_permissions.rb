module JobPermissions
  extend ActiveSupport::Concern
    include GlobalPermissions

    def administration_scope
      return true if global_scope
      allowed_roles = %w[ employee owner]

      return allowed_roles.include?(@current_user.role)
    end

    def read_scope
      allowed_roles = %w[ employer applicant]

      return allowed_roles.include?(@current_user.role)
    end
end