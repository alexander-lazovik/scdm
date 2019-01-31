# Model for updating RDLDrawReturn records
class RdlDrawReturnUpdate <  ActiveRecord::Base
  # Field      Description                                   Type  Len Dec
  # EADRS      Electronic Address                              A    50
  # MKTID      Market ID                                       P     2
  # DSTID      District ID                                     P     3
  # RTEID      Route ID                                        P     3
  # LOCID      Location ID                                     P     7
  # POID       Product Order ID                                P     3
  # RDLDTE     RDL Distribution Date                           P     8
  # DTDAYN     DT Net Draw for a day                           P     5
  # DAYZDR     Zero Draw Reason Code                           A     3
  # DTDAYR     DT Returns for a day                            P     5
  # RTNDTE     RDL Returns Date                                P     8
  # LRTNWK     Late Returns Week                               A     1
  # DAYUPD     Update Type                                     A     1
  # UDTUSR     Last Changed User                               A    10
  # UDTDAT     Last Changed Date                               P     6
  # UDTTIM     User/Date/Time Time                             P     6
  # UDTPRC     Last Changed Process                            A    10
  # UDTFNC     Last Changed Function                           A     7
  # UDTDATVIR  Last Changed Date (YYYYMMDD)                    P     8

  self.table_name = 'wpupdr'
  self.establish_connection :champion
  self.primary_keys = :eadrs, :mktid, :dstid, :rteid, :locid, :poid

  alias_attribute :email_address,                     :eadrs
  alias_attribute :market_id,                         :mktid
  alias_attribute :district_id,                       :dstid
  alias_attribute :route_id,                          :rteid
  alias_attribute :location_id,                       :locid
  alias_attribute :product_order_id,                  :poid
  alias_attribute :rdl_distribution_date,             :rdldte
  alias_attribute :returns_date,                      :rtndte
  alias_attribute :day_net_draw,                      :dtdayn
  alias_attribute :day_returns,                       :dtdayr
  alias_attribute :day_zero_draw_reason_code,         :dayzdr
  alias_attribute :week_late_returns,                 :lrtnwk
  alias_attribute :day_update_type,                   :dayupd

  after_initialize do |record|
    record.day_net_draw ||= 0
    record.day_returns ||= 0
    record.day_update_type ||= "N"
  end
end
