module ApplicantPermissions
  extend ActiveSupport::Concern

  included do
    before_action :authenticate, except: [ :create ]
    before_action :load_applicant, only: [:show, :update, :destroy]
  end

  def administration_scope
    allowed_roles = %w[ admin employee owner ]

    return allowed_roles.include?(@current_user.role)
  end

  def user_scope
    allowed_roles = %w[ applicant ]

    return allowed_roles.include?(@current_user.role) && @current_applicant.id == @current_user.id
  end

end