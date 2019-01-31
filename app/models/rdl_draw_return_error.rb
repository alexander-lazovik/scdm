# Route Delivery List Draw and Returns updating errors
class RdlDrawReturnError <  ActiveRecord::Base
  # EADRS      Electronic Address                              A    50
  # MKTID      Market ID                                       P     2
  # DSTID      District ID                                     P     3
  # RTEID      Route ID                                        P     3
  # LOCID      Location ID                                     P     7
  # POID       Product Order ID                                P     3
  # ERRDTE     Web Portal Error Date                           P     8
  # ERRFLD     Web Portal Field in Error                       A     1
  # ERRMSG     Error Message                                   A    80
  # UDTUSR     Last Changed User                               A    10
  # UDTDAT     Last Changed Date                               P     6
  # UDTTIM     User/Date/Time Time                             P     6
  # UDTPRC     Last Changed Process                            A    10
  # UDTFNC     Last Changed Function                           A     7
  # UDTDATVIR  Last Changed Date (YYYYMMDD)                    P     8

  self.table_name = 'wpmsgr'
  self.establish_connection :champion
  self.primary_keys = "eadrs", "mktid", "dstid", "rteid", "locid", "poid", "errdte", "errfld", "errmsg"

  belongs_to :rdl_draw_return, foreign_key: [:eadrs, :mktid, :dstid, :rteid, :locid, :poid],
                              primary_key: [:eadrs, :mktid, :dstid, :rteid, :locid, :poid]

  alias_attribute :email_address,         :eadrs
  alias_attribute :market_id,             :mktid
  alias_attribute :district_id,           :dstid
  alias_attribute :route_id,              :rteid
  alias_attribute :location_id,           :locid
  alias_attribute :product_order_id,      :poid
  alias_attribute :error_date,            :errdte
  alias_attribute :error_field,           :errfld
  alias_attribute :error_message,         :errmsg
  alias_attribute :last_changed_user,     :udtusr
  alias_attribute :last_changed_date,     :udtdat
  alias_attribute :user_date_time,        :udttim
  alias_attribute :last_changed_process,  :udtprc
  alias_attribute :last_changed_function, :udtfnc
end
