module ApplicationHelper
  def site
    Rails.configuration.x.site
  end

  def whatsapp_url(office)
    "https://wa.me/#{site[:whatsapp][office][:wa]}"
  end

  # Order here = order in the menus
  def nav_items
    {
      home: root_path,
      about: about_path,
      services: services_path,
      destinations: destinations_path,
      how_it_works: how_it_works_path,
      faq: faq_path,
      contact: contact_path,
      track: track_path
    }
  end
end
