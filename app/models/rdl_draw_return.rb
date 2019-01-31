# Route Delivery List Draw and Returns
class RdlDrawReturn <  ActiveRecord::Base
  # Field      Description                                   Type  Len Dec
  # EADRS      Electronic Address                              A    50
  # MKTID      Market ID                                       P     2
  # DSTID      District ID                                     P     3
  # RTEID      Route ID                                        P     3
  # LOCID      Location ID                                     P     7
  # POID       Product Order ID                                P     3
  # POSEQ      Product Order Sequence                          P     4
  # PRODID     Product ID                                      A     4
  # POTYID     Product Order Type ID                           A     3
  # RDLDTE     RDL Distribution Date                           P     8
  # RTNDTE     RDL Returns Date                                P     8
  # LRTNWK     Late Returns Week                               A     1
  # PODMAX     PO Drw Thrshld (Max)                            P     5
  # DTDAYN     DT Net Draw for a day                           P     5
  # DTDRWR     Draw Day Returns                                P     5
  # DTDAYR     DT Returns for a day                            P     5
  # DTRTNN     Net Draw for Returns Day                        P     5
  # DAYDOK     Draw edit for day allowed?                      A     1
  # DAYROK     Returns edit for day allowed?                   A     1
  # DAYTYP     Publication Day Type                            A     1
  # DAYZDR     Zero Draw Reason Code                           A     3
  # UDTUSR     Last Changed User                               A    10
  # UDTDAT     Last Changed Date                               P     6
  # UDTTIM     User/Date/Time Time                             P     6
  # UDTPRC     Last Changed Process                            A    10
  # UDTFNC     Last Changed Function                           A     7
  # UDTDATVIR  Last Changed Date (YYYYMMDD)                    P     8

  self.table_name = 'wpdrwr'
  self.establish_connection :champion
  self.primary_keys = :eadrs, :mktid, :dstid, :rteid, :locid, :poid

  belongs_to :rdl_location,
              foreign_key: [:eadrs, :mktid, :dstid, :rteid, :locid],
              primary_key: [:eadrs, :mktid, :dstid, :rteid, :locid]
  belongs_to :product, foreign_key: :prodid, primary_key: :prodid
  belongs_to :web_portal_route,
              foreign_key: [:eadrs, :mktid, :dstid, :rteid],
              primary_key: [:eadrs, :mktid, :dstid, :rteid]
  has_many :rdl_draw_return_errors,
            foreign_key: [:eadrs, :mktid, :dstid, :rteid, :locid, :poid],
            primary_key: [:eadrs, :mktid, :dstid, :rteid, :locid, :poid]

  scope :join_product, -> {
    joins(:product)
    .select('wpdrwr.*, prod.prodrd as product_short_name')
  }

  scope :distinct_product, -> {
    select("prod.prodid, prod.prodrd")
    .joins(:product)
    .distinct
  }

  scope :ordered_by_prod_seq, -> { order(poseq: :asc) }

  scope :product_totals, -> {
    select("wpdrwr.eadrs, wpdrwr.mktid, wpdrwr.dstid, wpdrwr.rteid, wpdrwr.prodid,
      SUM(CASE WHEN dtdayn < 0 THEN 0 ELSE dtdayn END) as dtdayn,
      SUM(CASE WHEN dtdayr < 0 THEN 0 ELSE dtdayr END) as dtdayr")
    .group("wpdrwr.eadrs, wpdrwr.mktid, wpdrwr.dstid, wpdrwr.rteid, wpdrwr.prodid")
  }

  scope :sum_totals, -> {
    select("wpdrwr.eadrs, wpdrwr.mktid, wpdrwr.dstid, wpdrwr.rteid,
        SUM(CASE WHEN dtdayn < 0 THEN 0 ELSE dtdayn END) as dtdayn,
        SUM(CASE WHEN dtdayr < 0 THEN 0 ELSE dtdayr END) as dtdayr")
    .group("wpdrwr.eadrs, wpdrwr.mktid, wpdrwr.dstid, wpdrwr.rteid")
  }

  alias_attribute :email_address,                     :eadrs
  alias_attribute :market_id,                         :mktid
  alias_attribute :district_id,                       :dstid
  alias_attribute :route_id,                          :rteid
  alias_attribute :location_id,                       :locid
  alias_attribute :product_order_id,                  :poid
  alias_attribute :product_order_sequence,            :poseq
  alias_attribute :product_id,                        :prodid
  alias_attribute :product_order_type_id,             :potyid
  alias_attribute :rdl_distribution_date,             :rdldte
  alias_attribute :returns_date,                      :rtndte
  alias_attribute :week_late_returns,                 :lrtnwk
  alias_attribute :product_order_draw_threshold_max,  :podmax

  alias_attribute :day_net_draw,                      :dtdayn
  alias_attribute :day_returns,                       :dtdayr
  alias_attribute :draw_day_returns,                  :dtdrwr
  alias_attribute :returns_day_net_draw,              :dtrtnn
  alias_attribute :day_draw_edit_allowed,             :daydok
  alias_attribute :day_returns_edit_allowed,          :dayrok
  alias_attribute :day_publication_day_type,          :daytyp
  alias_attribute :day_zero_draw_reason_code,         :dayzdr

  alias_attribute :change_user,                       :udtusr
  alias_attribute :change_date,                       :udtdat
  alias_attribute :user_date_time,                    :udttim
  alias_attribute :last_changed_process,              :udtprc
  alias_attribute :last_changed_function,             :udtfnc
  alias_attribute :last_changed_date,                 :udtdatvir

  attr_accessor :modified
  attr_accessor :day_update_type

  validates :day_returns, returns: true
  validates :day_net_draw, draw: true

  # remove blanks form  values
  def to_param
    super.delete(' ')
  end

  # initialize virtual attributes
  after_find do |record|
    record.day_update_type = "N"
    record.modified = "N"
  end

  # check if record was modified
  def self.modified?(record)
    record.values_at(:day_update_type).any? { |value| !(value == "N" || value.blank?) }
  end

  # Load record and assign attributes
  def self.change(id, attributes)
    return unless modified?(attributes)

    record = find(id)
    record.assign_attributes(attributes) if record
    record
  end

  # Save record using another model LocationDrawReturnUpdate
  def save
    record = RdlDrawReturnUpdate.new(attributes_to_update)
    record.save(validate: false)
  end

  def week_late_returns?
    week_late_returns == 'Y'
  end

  def draw_edit_allowed?
    day_draw_edit_allowed == 'Y'
  end

  def returns_edit_allowed?
    day_returns_edit_allowed == 'Y'
  end

  def show_day?
    day_net_draw > -1
  end

  def zero_draw_reason_visible?
    day_net_draw == 0 && !day_zero_draw_reason_code.blank?
  end

  private

    # Get a hash of attributes for updating
    def attributes_to_update
      attributes.slice(
        "eadrs", "mktid", "dstid", "rteid", "locid", "poid",
        "dtdayn", "dtdayr", "dayzdr", "rdldte", "rtndte", "lrtnwk"
      ).merge( day_update_type: day_update_type )
    end
end
