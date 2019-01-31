class Message <  ActiveRecord::Base

  # Field   Description                   Type  Len Dec
  # EADRS     Electronic Address            A     50
  # MKTID     Market ID                     P     2
  # DSTID     District ID                   P     3
  # RTEID     Route ID                      P     3
  # BMSGID    Brd Message ID                A     5
  # BMSGTX    Brd Message Text              A     75
  # UDTUSR    Last Changed User             A     10
  # UDTDAT    Last Changed Date             P     6
  # UDTTIM    User/Date/Time Time           P     6
  # UDTPRC    Last Changed Process          A     10
  # UDTFNC    Last Changed  Function        A     7
  # UDTDATVIR Last Changed Date (YYYYMMDD)  P     8

  self.table_name = 'wpbmsg'
  self.establish_connection :champion
  self.primary_key = 'eadrs'

  belongs_to :portal_user, foreign_key: :eadrs, primary_key: :eadrs

  alias_attribute :email_address,         :eadrs
  alias_attribute :market_id,             :mktid
  alias_attribute :district_id,           :dstid
  alias_attribute :route_id,              :rteid
  alias_attribute :id,                    :bmsgid
  alias_attribute :message_text,          :bmsgtx
  alias_attribute :last_changed_user,     :udtusr
  alias_attribute :last_changed_date,     :udtdat
  alias_attribute :user_date_time,        :udttim
  alias_attribute :last_changed_process,  :udtprc
  alias_attribute :last_changed_function, :udtfnc
  alias_attribute :last_changed_date,     :udtdatvir

# TODO
# portal_user_type.asgtyp display left menu for route or blue chip based on this value

end
