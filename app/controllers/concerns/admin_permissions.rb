module AdminPermissions
  extend ActiveSupport::Concern
    include GlobalPermissions

    included do
      before_action :administration_scope, only: [:index, :create, :show, :update, :destroy]
    end

    def administration_scope
      return true if global_scope   
    end
end