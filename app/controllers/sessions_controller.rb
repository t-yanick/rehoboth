class SessionsController < ApplicationController
  layout "auth"
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_session_path, alert: t("sessions.rate_limited") }

  def new; end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))

    if user&.active?
      if user.otp_enabled?
        # Password OK: remember who is signing in, then ask for the code
        session[:pending_otp_user_id] = user.id
        session[:pending_otp_at] = Time.current.to_i
        redirect_to new_two_factor_session_path
      else
        start_new_session_for user
        redirect_to after_authentication_url
      end
    else
      redirect_to new_session_path, alert: t("sessions.invalid")
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
