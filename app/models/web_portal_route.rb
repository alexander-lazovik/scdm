# web_portal_route.rb - defines the WebPortalRoute class
#  ideally this could be refactored to just a Route or WebRoute
#  since routes while not reserved have a meaning already
class WebPortalRoute <  ActiveRecord::Base
  # Field     Description                                       Type        Len Dec
  # EADRS     Electronic Address                                A           50
  # MKTID     Market ID                                         P           2
  # DSTID     District ID                                       P           3
  # RTEID     Route ID                                          P           3
  # RTEDSC    Route Description                                 A           30
  # RDLEDT    RDL Earliest Managed Date                         P           8
  # RDLLDT    RDL Latest Managed Date                           P           8
  # MWKEDT    Earliest Managed Week                             P           8
  # MWKLDT    Latest Managed Week P 8 UDTUSR Last Changed User  A           10
  # UDTDAT    Last Changed Date                                 P           6
  # UDTTIM    User/Date/Time Time                               P           6
  # UDTPRC    Last Changed Process                              A           10
  # UDTFNC    Last Changed Function                             A           7
  # UDTDATVIR Last Changed Date (YYYYMMDD)                      P           8

  self.table_name = 'wprlst'
  self.establish_connection :champion
  self.primary_keys = :eadrs, :mktid, :dstid, :rteid

  belongs_to :portal_user, foreign_key: :eadrs, primary_key: :eadrs
  has_many :route_products, class_name: 'RouteProduct',
            foreign_key: [:eadrs, :mktid, :dstid, :rteid],
            primary_key: [:eadrs, :mktid, :dstid, :rteid]
  has_many :locations, class_name: 'RouteLocation',
            foreign_key: [:eadrs, :mktid, :dstid, :rteid],
            primary_key: [:eadrs, :mktid, :dstid, :rteid]
  has_many :draws_and_returns, :through => :locations
  has_many :rdl_locations,
            foreign_key: [:eadrs, :mktid, :dstid, :rteid],
            primary_key: [:eadrs, :mktid, :dstid, :rteid]
  has_many :rdl_draw_returns, :through => :rdl_locations

  alias_attribute :email_address,              :eadrs
  alias_attribute :market_id,                  :mktid
  alias_attribute :district_id,                :dstid
  alias_attribute :route_id,                   :rteid
  alias_attribute :route_description,          :rtedsc
  alias_attribute :rdl_earliest_managed_date,  :rdledt
  alias_attribute :rdl_latest_managed_date,    :rdlldt
  alias_attribute :earliest_managed_week,      :mwkedt
  alias_attribute :latest_manged_week,         :mwkldt
  alias_attribute :last_changed_date,          :udtdat
  alias_attribute :user_date_time,             :udttim
  alias_attribute :last_changed_process,       :udtprc
  alias_attribute :last_changed_function,      :udtfnc
  alias_attribute :last_changed_dtae,          :udtatvir

  attr_accessor :week_end_date
  attr_accessor :distribution_date

  after_initialize do |record|
    record.week_end_date ||= Date.today
    record.distribution_date ||= Date.today
  end

  def eadrs
    self[:eadrs].strip
  end

  def to_param
    super.delete(' ')
  end

  # Delete draw and returns from work table for the current route id
  def clear_route
    route_id = attributes.slice(*self.class.primary_keys)
    LocationDrawReturnUpdate.delete_all(route_id)
  end

  # Delete draw and returns from work table for the current RDL
  def clear_rdl
    route_id = attributes.slice(*self.class.primary_keys)
    RdlDrawReturnUpdate.delete_all(route_id)
  end
end
