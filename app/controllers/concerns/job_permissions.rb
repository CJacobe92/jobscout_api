module JobPermissions
  extend ActiveSupport::Concern
    include GlobalPermissions

    def administration_scope
      allowed_roles = %w[ employee owner]

      return allowed_roles.include?(@current_user.role)
    end
end