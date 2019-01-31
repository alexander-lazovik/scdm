# Valid Users that have logged into the app
# :reek:ControlParameter
class PortalUser <  ActiveRecord::Base

  # Field      Description                                   Type  Len Dec
  # SESSID     WP Session ID                                   A    25
  # EADRS      Electronic Address                              A    50
  # WPUNAM     Web Portal User Name                            A    30
  # PHNNBR     Phone Number                                    P    10
  # UDTUSR     Last Changed User                               A    10
  # UDTDAT     Last Changed Date                               P     6
  # UDTTIM     User/Date/Time Time                             P     6
  # UDTPRC     Last Changed Process                            A    10
  # UDTFNC     Last Changed Function                           A     7
  # UDTDATVIR  Last Changed Date (YYYYMMDD)                    P     8

  self.table_name = 'wpauth'
  self.establish_connection :champion unless Rails.env.test?
  self.primary_key = 'sessid'

  ROUTE = 'RTE'
  BLUE_CHIP = 'BCE'

  has_many :portal_user_types, foreign_key: :sessid, primary_key: :sessid
  has_many :messages, foreign_key: :eadrs, primary_key: :eadrs
  has_one :portal_user_error, foreign_key: :sessid, primary_key: :sessid

  has_many :web_portal_routes, foreign_key: :eadrs, primary_key: :eadrs
  has_many :draw_and_returns_on_route, class_name: 'LocationDrawReturn', foreign_key: :eadrs, primary_key: :eadrs

  attr_accessor :routes_filled, :messages_read
  #attr_accessor :product_id
  attr_accessor :new_email_address, :new_email_address_confirmation
  attr_accessor :current_password, :new_password, :new_password_confirmation

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :new_email_address,
                    presence: true,
                    format: { with: VALID_EMAIL_REGEX, message: "Your email address does not meet the standard email address formatting of 'abc@def.xyz'" },
                    length: { maximum: 50 },
                    confirmation: { case_sensitive: false, message: "Your new email addresses do not match" },
                    new_email: true, #custom validator: new_email_validator
                    on: :update_email #validate only in :update_email context

  validates :new_email_address_confirmation, presence: true, on: :update_email

  validates :current_password,
    current_password: true, #custom validator: current_password_validator
    presence: true,
    on: [:update_password, :update_email]

  VALID_PASSWORD_REGEX = /(?=.*\d)/
  validates :new_password,
      presence: true,
      format: { with: VALID_PASSWORD_REGEX, message: "Your new password does not meet the password strength requirements" },
      length: { in: 6..10, too_long: "%{count} characters is the maximum allowed",
        too_short: "%{count} characters is the minimum allowed" },
      confirmation: { case_sensitive: true, message: "Your new passwords do not match" },
      on: :update_password #validate only in :update_password context

  validates :new_password_confirmation, presence: true, on: :update_password

  alias_attribute :session_id,            :sessid
  alias_attribute :email_address,         :eadrs
  alias_attribute :user_name,             :wpunam
  alias_attribute :phone_number,          :phnnbr
  alias_attribute :last_update_user,      :udtusr
  alias_attribute :last_update_date,      :udtdat
  alias_attribute :user_date_time,        :udttim
  alias_attribute :last_changed_process,  :udtprc
  alias_attribute :last_changed_function, :udtfnc
  alias_attribute :last_changed_date,     :udtdatvir

  # so we have some values for our attr_accessors that aren't int he Champion Model
  def after_initialize
    return unless new_record?
    self.routes_filled  = false
    self.messages_read  = false
  end

  def has_routes_or_blue_chip(rte_or_bce)
    self.portal_user_types.any?{ |route_type| route_type.asgtyp == rte_or_bce }
  end

  def id
    self[:sessid].strip
  end

  def sessid
    self[:sessid].strip
  end

  def eadrs
    self[:eadrs].strip
  end

end
