# route_product.rb contians the class definition for the products on a route
class RouteProduct <  ActiveRecord::Base
  # Field     Description                                       Type        Len Dec
  # EADRS     Electronic Address                                A           50
  # MKTID     Market ID                                         P           2
  # DSTID     District ID                                       P           3
  # RTEID     Route ID                                          P           3
  # PRODID    Product ID A 4 UDTUSR Last Changed User           A           10
  # UDTDAT    Last Changed Date                                 P           6
  # UDTTIM    User/Date/Time Time                               P           6
  # UDTPRC    Last Changed Process                              A           10
  # UDTFNC    Last Changed Function                             A           7
  # UDTDATVIR Last Changed Date (YYYYMMDD)                      P

  self.table_name = 'wprtpr'
  self.establish_connection :champion
  self.primary_keys = :eadrs, :mktid, :dstid, :rteid, :prodid

  belongs_to :web_portal_route, foreign_key: [:eadrs, :mktid, :dstid, :rteid],
                                primary_key: [:eadrs, :mktid, :dstid, :rteid]
  has_one :product, foreign_key: :prodid, primary_key: :prod_id

  alias_attribute :email_address,         :eadrs
  alias_attribute :market_id,             :mktid
  alias_attribute :district_id,           :dstid
  alias_attribute :route_id,              :rteid
  alias_attribute :product_id,            :prodid
  alias_attribute :last_changed_date,     :udtdat
  alias_attribute :user_date_time,        :udttim
  alias_attribute :last_changed_process,  :udtprc
  alias_attribute :last_chnaged_function, :udtfnc
  alias_attribute :last_update_date,      :udtdatvir
end













