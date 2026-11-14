# First HQ admin: ADMIN_EMAIL=... ADMIN_NAME=... ADMIN_PASSWORD=... bin/rails db:seed
if ENV["ADMIN_EMAIL"].present?
  User.find_or_create_by!(email_address: ENV["ADMIN_EMAIL"].strip.downcase) do |user|
    user.name = ENV.fetch("ADMIN_NAME", "Administrator")
    user.role = "hq_admin"
    user.password = ENV.fetch("ADMIN_PASSWORD")
  end
end
