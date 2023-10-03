module TenantPermissions
  extend ActiveSupport::Concern
    include GlobalPermissions
    
    def self_read_scope
      allowed_roles = %w[ owner ]

      return allowed_roles.include?(@current_user.role) && @current_tenant.id == @current_user.tenant_id
    end
end