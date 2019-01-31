class PortalUserError <  ActiveRecord::Base

  # Field      Description                                   Type  Len Dec
  # SESSID     WP Session ID                                   A    25
  # EADRS      Electronic Address                              A    50
  # ERRMSG     Error Message                                   A    80
  # ----------------------------------------------------------------------
  # UDTUSR     Last Changed User                               A    10
  # UDTDAT     Last Changed Date                               P     6
  # UDTTIM     User/Date/Time Time                             P     6
  # UDTPRC     Last Changed Process                            A    10
  # UDTFNC     Last Changed Function                           A     7
  # UDTDATVIR  Last Changed Date (YYYYMMDD)                    P     8


  self.table_name = 'wpmsgu'
  self.establish_connection :champion
  self.primary_key = 'sessid'

  belongs_to :portal_user, foreign_key: :sessid, primary_key: :sessid

  alias_attribute :session_id,            :sessid
  alias_attribute :email_address,         :eadrs
  alias_attribute :error_message,         :errmsg
  alias_attribute :last_changed_user,     :udtusr
  alias_attribute :last_changed_date,     :udtdat
  alias_attribute :user_date_time,        :udttim
  alias_attribute :last_changed_process,  :udtprc
  alias_attribute :last_changed_function, :udtfnc
#  alias_attribute :last_changed_date,     :udtdatvir

end
