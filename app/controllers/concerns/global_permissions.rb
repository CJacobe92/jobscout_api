module GlobalPermissions
  extend ActiveSupport::Concern

  def global_scope
    allowed_roles = %w[ admin ]
    
    return allowed_roles.include?(@current_user.role)
  end
  
end 