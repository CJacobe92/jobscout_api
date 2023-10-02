module ApplicantPermissions
  extend ActiveSupport::Concern
    include GlobalPermissions

    def administration_scope

      allowed_roles = %w[ owner ]

      return allowed_roles.include?(@current_user.role) && @current_owner.id == @current_user.id
    end
end