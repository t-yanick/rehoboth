class TwoFactorSessionsController < ApplicationController
  layout "auth"
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_session_path, alert: t("sessions.rate_limited") }
  before_action :set_pending_user

  def new; end

  def create
    if @user.verify_otp(params[:code])
      clear_pending
      start_new_session_for @user
      redirect_to after_authentication_url
    else
      redirect_to new_two_factor_session_path, alert: t("two_factor_sessions.invalid")
    end
  end

  private

  # The password step must have happened in the last 5 minutes
  def set_pending_user
    id = session[:pending_otp_user_id]
    started = session[:pending_otp_at].to_i
    @user = User.find_by(id: id) if id && started > 5.minutes.ago.to_i

    return if @user&.active?

    clear_pending
    redirect_to new_session_path, alert: t("two_factor_sessions.expired")
  end

  def clear_pending
    session.delete(:pending_otp_user_id)
    session.delete(:pending_otp_at)
  end
end
