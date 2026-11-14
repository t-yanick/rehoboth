class User < ApplicationRecord
  ROLES = %w[hq_admin warehouse_staff country_manager agent].freeze

  has_secure_password
  has_many :sessions, dependent: :destroy

  enum :role, ROLES.index_with(&:itself), validate: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true,
                            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :locale, inclusion: { in: %w[en fr] }
  validates :password, length: { minimum: 12 }, allow_nil: true
end
