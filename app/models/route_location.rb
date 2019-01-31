class RouteLocation <  ActiveRecord::Base
  # Field      Description                                   Type  Len Dec
  # EADRS      Electronic Address                              A    50
  # MKTID      Market ID                                       P     2
  # DSTID      District ID                                     P     3
  # RTEID      Route ID                                        P     3
  # LOCID      Location ID                                     P     7
  # LOCSQ      Location Sequence                               P     4
  # LOCNAM     Location Name                                   A    50
  # ADDR01     Address line 1                                  A    45
  # LOCCPH     Loc Contact Phone Number                        P    10
  # UDTUSR     Last Changed User                               A    10
  # UDTDAT     Last Changed Date                               P     6
  # UDTTIM     User/Date/Time Time                             P     6
  # UDTPRC     Last Changed Process                            A    10
  # UDTFNC     Last Changed Function                           A     7

  alias_attribute :email_address,         :eadrs
  alias_attribute :market_id,             :mktid
  alias_attribute :district_id,           :dstid
  alias_attribute :route_id,              :rteid
  alias_attribute :id,                    :locid
  alias_attribute :sequence,              :locsq
  alias_attribute :location_name,         :locnam
  alias_attribute :address_line,          :addr01
  alias_attribute :location_phone,        :loccph
  alias_attribute :change_user,           :udtusr
  alias_attribute :change_date,           :udtdat
  alias_attribute :change_time,           :udttim
  alias_attribute :last_changed_process,  :udtprc
  alias_attribute :last_changed_function, :udtfnc

  self.table_name = 'wplocw'
  self.establish_connection :champion
  self.primary_keys = :eadrs, :mktid, :dstid, :rteid, :locid

  belongs_to :web_portal_route, foreign_key: [:eadrs, :mktid, :dstid, :rteid],
                                 primary_key: [:eadrs, :mktid, :dstid, :rteid]
  has_many :draws_and_returns, class_name: 'LocationDrawReturn',
            foreign_key: [:eadrs, :mktid, :dstid, :rteid, :locid],
            primary_key: [:eadrs, :mktid, :dstid, :rteid, :locid]

  scope :ordered_by_sequence, -> { order(sequence: :asc) }
end
