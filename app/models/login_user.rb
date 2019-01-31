class LoginUser

  include ActiveModel::Model
  require 'active_support/all'
  include LoginConcerns

  # attr_accessor :SESSID
  # attr_accessor :EADRS
  # attr_accessor :WPUNAM
  # attr_accessor :PHNNBR

  attr_accessor :session_id, :email_address, :password

  validates :session_id, :email_address, presence: true
  validates :email_address, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def initialize(login_user = {})
    if login_user.nil?
      @email_address = ''
      @password = ''
      @session_id = get_new_session_id
    else
      @email_address = login_user[:email_address].nil? ? '' : upcase_email_for_lansa(login_user[:email_address])
      @password = login_user[:password] || ''
      @session_id = login_user[:session_id] || get_new_session_id
    end
  end

  def login?
    y = create_sign_on_json(self)
    login_results = LansaIntegratorService.new(service: 'SCDM_SIGNON', query: y).call
    login_results && login_results.success == true && login_results.wppswdok == 'Y' && login_results.wpscdmp =='Y' && login_results.wpactive == 'Y'
  end

  def validate_password()
    if self.login?
    # if the current password is correct drop new session that we have just created
      self.logout
      return true
    else
      return false
    end
  end

  def logout
    self.password = ''
    self.login?
  end

private

  def get_new_session_id
    self.session_id = SecureRandom.hex(12).to_s
  end

  # Note we only do this because LI and Champion can only accept
  # uppercase email addresses. emails addresses are not case sensitive
  def upcase_email_for_lansa(email_address)
    email_address.strip.upcase
  end
end
