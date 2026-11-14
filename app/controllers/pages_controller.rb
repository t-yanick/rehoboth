class PagesController < ApplicationController
  allow_unauthenticated_access

  def home; end
  def about; end
  def services; end
  def destinations; end
  def how_it_works; end
  def faq; end
  def contact; end
  def track; end

  private

  # Keep /en or /fr in every public link
  def default_url_options
    { locale: I18n.locale }
  end
end
