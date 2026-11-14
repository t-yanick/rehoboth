class User < ApplicationRecord
  ROLES = %w[hq_admin warehouse_staff country_manager agent].freeze
  OTP_ISSUER = "Rehoboth Admin".freeze

  has_secure_password
  has_many :sessions, dependent: :destroy

  encrypts :otp_secret

  enum :role, ROLES.index_with(&:itself), validate: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true,
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :locale, inclusion: { in: %w[en fr] }
  validates :password, length: { minimum: 12 }, allow_nil: true

  def otp_enabled?
    otp_enabled_at.present?
  end

  def otp_provisioning_uri
    ROTP::TOTP.new(otp_secret, issuer: OTP_ISSUER).provisioning_uri(email_address)
  end

  # True if the code is valid and hasn't been used before (blocks replay)
  def verify_otp(code)
    return false if otp_secret.blank?

    totp = ROTP::TOTP.new(otp_secret, issuer: OTP_ISSUER)
    timestamp = totp.verify(code.to_s.gsub(/\s/, ""), drift_behind: 30, after: otp_last_used_at)
    return false unless timestamp

    update_column(:otp_last_used_at, timestamp)
    true
  end

  def reset_otp!
    update!(otp_secret: nil, otp_enabled_at: nil, otp_last_used_at: nil)
  end
end
