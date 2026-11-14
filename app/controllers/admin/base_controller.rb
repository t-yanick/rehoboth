module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :require_active_staff
    before_action :require_two_factor_setup

    private

    def require_active_staff
      return if Current.user&.active?

      terminate_session
      redirect_to new_session_path, alert: t("admin.auth.inactive")
    end

    # HQ admins can't use the admin until two-step verification is on
    def require_two_factor_setup
      return unless Current.user.hq_admin? && !Current.user.otp_enabled?

      redirect_to new_admin_two_factor_path, alert: t("admin.auth.two_factor_required")
    end

    def require_hq_admin
      redirect_to admin_root_path, alert: t("admin.auth.forbidden") unless Current.user.hq_admin?
    end
  end
end
