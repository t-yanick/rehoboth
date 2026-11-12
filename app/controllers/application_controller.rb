class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  around_action :switch_locale

  private

  def switch_locale(&action)
    I18n.with_locale(params[:locale] || I18n.default_locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
