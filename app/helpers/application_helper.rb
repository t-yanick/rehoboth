module ApplicationHelper
  def site
    Rails.configuration.x.site
  end

  # WhatsApp link for one of the two Asian offices (:vietnam / :china)
  def whatsapp_url(office)
    wa_url(site[:whatsapp][office][:wa])
  end

  # WhatsApp link for any number in wa.me format (digits only, country code first)
  def wa_url(number)
    "https://wa.me/#{number}"
  end

  # Phone link: "+237 000 000 000" -> "tel:+237000000000"
  def tel_url(display_number)
    "tel:#{display_number.to_s.delete(' ')}"
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
