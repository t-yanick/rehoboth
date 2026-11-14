class ApplicationController < ActionController::Base
  include Authentication

  around_action :switch_locale

  private

  # Public pages: language from the URL. Admin: the staff member's chosen language.
  def switch_locale(&action)
    I18n.with_locale(requested_locale, &action)
  end

  def requested_locale
    available = I18n.available_locales.map(&:to_s)
    [ params[:locale], Current.user&.locale ].map(&:to_s).find { |l| available.include?(l) } ||
      I18n.default_locale
  end
end
