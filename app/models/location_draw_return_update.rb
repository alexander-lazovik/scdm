# Model for updating LocationDrawReturn records
class LocationDrawReturnUpdate <  ActiveRecord::Base
  # Field      Description                                   Type  Len Dec
  # EADRS      Electronic Address                              A    50
  # MKTID      Market ID                                       P     2
  # DSTID      District ID                                     P     3
  # RTEID      Route ID                                        P     3
  # LOCID      Location ID                                     P     7
  # POID       Product Order ID                                P     3
  # DWKEDT     Drw Trns Wk End Date                            P     8
  # DTMONN     DT Monday Net Draw                              P     5
  # MONZDR     Zero Draw Reason Code                           A     3
  # DTMONR     DT Monday Returns                               P     5
  # MONUPD     Update Type                                     A     1
  # DTTUEN     DT Tuesday Net Draw                             P     5
  # TUEZDR     Zero Draw Reason Code                           A     3
  # DTTUER     DT Tuesday Returns                              P     5
  # TUEUPD     Update Type                                     A     1
  # DTWEDN     DT Wednesday Net Drw                            P     5
  # WEDZDR     Zero Draw Reason Code                           A     3
  # DTWEDR     DT Wednesday Returns                            P     5
  # WEDUPD     Update Type                                     A     1
  # DTTHRN     DT Thursday Net Drw                             P     5
  # THRZDR     Zero Draw Reason Code                           A     3
  # DTTHRR     DT Thursday Returns                             P     5
  # THRUPD     Update Type                                     A     1
  # DTFRIN     DT Friday Net Draw                              P     5
  # FRIZDR     Zero Draw Reason Code                           A     3
  # DTFRIR     DT Friday Returns                               P     5
  # FRIUPD     Update Type                                     A     1
  # DTSATN     DT Saturday Net Draw                            P     5
  # SATZDR     Zero Draw Reason Code                           A     3
  # DTSATR     DT Saturday Returns                             P     5
  # SATUPD     Update Type                                     A     1
  # DTSUNN     DT Sunday Net Draw                              P     5
  # SUNZDR     Zero Draw Reason Code                           A     3
  # DTSUNR     DT Sunday Returns                               P     5
  # SUNUPD     Update Type                                     A     1
  # UDTUSR     Last Changed User                               A    10
  # UDTDAT     Last Changed Date                               P     6
  # UDTTIM     User/Date/Time Time                             P     6
  # UDTPRC     Last Changed Process                            A    10
  # UDTFNC     Last Changed Function                           A     7

  self.table_name = 'wpupdw'
  self.establish_connection :champion
  self.primary_keys = :eadrs, :mktid, :dstid, :rteid, :locid, :poid

  alias_attribute :email_address,                     :eadrs
  alias_attribute :market_id,                         :mktid
  alias_attribute :district_id,                       :dstid
  alias_attribute :route_id,                          :rteid
  alias_attribute :location_id,                       :locid
  alias_attribute :product_order_id,                  :poid
  alias_attribute :week_end_date,                     :dwkedt
  alias_attribute :monday_net_draw,                   :dtmonn
  alias_attribute :monday_returns,                    :dtmonr
  alias_attribute :monday_zero_draw_reason_code,      :monzdr
  alias_attribute :monday_update_type,                :monupd
  alias_attribute :tuesday_net_draw,                  :dttuen
  alias_attribute :tuesday_returns,                   :dttuer
  alias_attribute :tuesday_zero_draw_reason_code,     :tuezdr
  alias_attribute :tuesday_update_type,               :tueupd
  alias_attribute :wednesday_net_draw,                :dtwedn
  alias_attribute :wednesday_returns,                 :dtwedr
  alias_attribute :wednesday_zero_draw_reason_code,   :wedzdr
  alias_attribute :wednesday_update_type,             :wedupd
  alias_attribute :thursday_net_draw,                 :dtthrn
  alias_attribute :thursday_returns,                  :dtthrr
  alias_attribute :thursday_zero_draw_reason_code,    :thrzdr
  alias_attribute :thursday_update_type,              :thrupd
  alias_attribute :friday_net_draw,                   :dtfrin
  alias_attribute :friday_returns,                    :dtfrir
  alias_attribute :friday_zero_draw_reason_code,      :frizdr
  alias_attribute :friday_update_type,                :friupd
  alias_attribute :saturday_net_draw,                 :dtsatn
  alias_attribute :saturday_returns,                  :dtsatr
  alias_attribute :saturday_zero_draw_reason_code,    :satzdr
  alias_attribute :saturday_update_type,              :satupd
  alias_attribute :sunday_net_draw,                   :dtsunn
  alias_attribute :sunday_returns,                    :dtsunr
  alias_attribute :sunday_zero_draw_reason_code,      :sunzdr
  alias_attribute :sunday_update_type,                :sunupd

  after_initialize do |record|
    record.monday_net_draw ||= 0
    record.monday_returns ||= 0
    record.monday_update_type ||= "N"
    record.tuesday_net_draw ||= 0
    record.tuesday_returns ||= 0
    record.tuesday_update_type ||= "N"
    record.wednesday_net_draw ||= 0
    record.wednesday_returns ||= 0
    record.wednesday_update_type ||= "N"
    record.thursday_net_draw ||= 0
    record.thursday_returns ||= 0
    record.thursday_update_type ||= "N"
    record.friday_net_draw ||= 0
    record.friday_returns ||= 0
    record.friday_update_type ||= "N"
    record.saturday_net_draw ||= 0
    record.saturday_returns ||= 0
    record.saturday_update_type ||= "N"
    record.sunday_net_draw ||= 0
    record.sunday_returns ||= 0
    record.sunday_update_type ||= "N"
  end
end
