module ApplicantPermissions
  extend ActiveSupport::Concern
    include GlobalPermissions

    def administration_scope
      return true if global_scope

      allowed_roles = %w[ owner employee ]

      return allowed_roles.include?(@current_user.role)
    end

    def self_read_scope
      allowed_roles = %w[ applicant ]

      return allowed_roles.include?(@current_user.role) && @current_applicant.id == @current_user.id
    end

    def read_scope
      allowed_roles = %w[ employer ]
      
      return allowed_roles.include?(@current_user.role)
    end
end