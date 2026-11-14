module Admin
  class TwoFactorsController < BaseController
    skip_before_action :require_two_factor_setup

    def show; end

    def new
      return redirect_to(admin_two_factor_path) if Current.user.otp_enabled?

      Current.user.update!(otp_secret: ROTP::Base32.random) if Current.user.otp_secret.blank?
      svg = RQRCode::QRCode.new(Current.user.otp_provisioning_uri)
                           .as_svg(module_size: 4, use_path: true, viewbox: true)
      @qr_data_uri = "data:image/svg+xml;base64,#{Base64.strict_encode64(svg)}"
    end

    def create
      if Current.user.verify_otp(params[:code])
        Current.user.update!(otp_enabled_at: Time.current)
        redirect_to admin_root_path, notice: t(".enabled")
      else
        redirect_to new_admin_two_factor_path, alert: t(".invalid")
      end
    end

    def destroy
      return redirect_to(admin_two_factor_path, alert: t(".required_for_hq")) if Current.user.hq_admin?

      Current.user.reset_otp!
      redirect_to admin_two_factor_path, notice: t(".disabled")
    end
  end
end
