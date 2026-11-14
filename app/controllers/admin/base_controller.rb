module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :require_active_staff

    private

    def require_active_staff
      return if Current.user&.active?

      terminate_session
      redirect_to new_session_path, alert: t("admin.auth.inactive")
    end

    def require_hq_admin
      redirect_to admin_root_path, alert: t("admin.auth.forbidden") unless Current.user.hq_admin?
    end
  end
end
