class LocationDrawReturn <  ActiveRecord::Base
  # Field     Description                                       Type        Len Dec
  # EADRS       Electronic Address                                A           50
  # MKTID       Market ID                                         P           2
  # DSTID       District ID                                       P           3
  # RTEID       Route ID                                          P           3
  # LOCID       Location ID                                       P           7
  # POID        Product Order ID                                  P           3
  # POSEQ       Product Order Sequence                            P           4
  # PRODID      Product ID                                        A           4
  # POTYID      Product Order Type ID                             A           3
  # PODMAX      PO Drw Thrshld (Max)                              P           5
  # DTMONN      DT Monday Net Draw                                P           5
  # DTMONR      DT Monday Returns                                 P           5+
  # MONDOK      Draw edit for day allowed?                        A           1
  # MONROK      Returns edit for day allowed?                     A           1
  # MONDTP      Publication Day Type                              A           1
  # MONZDR      Zero Draw Reason Code                             A           3
  # DTTUEN      DT Tuesday Net Draw                               P           5
  # DTTUER      DT Tuesday Returns                                P           5
  # TUEDOK      Draw edit for day allowed?                        A           1
  # TUEROK      Returns edit for day allowed?                     A           1
  # TUEDTP      Publication Day Type                              A           1
  # TUEZDR      Zero Draw Reason Code                             A           3
  # DTWEDN      DT Wednesday Net Drw                              P           5
  # DTWEDR      DT Wednesday Returns                              P           5+
  # WEDDOK      Draw edit for day allowed?                        A           1
  # WEDROK      Returns edit for day allowed?                     A           1
  # WEDDTP      Publication Day Type                              A           1
  # WEDZDR      Zero Draw Reason Code                             A           3
  # DTTHRN      DT Thursday Net Drw                               P           5
  # DTTHRR      DT Thursday Returns                               P           5
  # THRDOK      Draw edit for day allowed?                        A           1
  # THRROK      Returns edit for day allowed?                     A           1
  # THRDTP      Publication Day Type                              A           1
  # THRZDR      Zero Draw Reason Code                             A           3
  # DTFRIN      DT Friday Net Draw                                P           5
  # DTFRIR      DT Friday Returns                                 P           5+
  # FRIDOK      Draw edit for day allowed?                        A           1
  # FRIROK      Returns edit for day allowed?                     A           1
  # FRIDTP      Publication Day Type                              A           1
  # FRIZDR      Zero Draw Reason Code                             A           3
  # DTSATN      DT Saturday Net Draw                              P           5
  # DTSATR      DT Saturday Returns                               P           5
  # SATDOK      Draw edit for day allowed?                        A           1
  # SATROK      Returns edit for day allowed?                     A           1
  # SATDTP      Publication Day Type                              A           1
  # SATZDR      Zero Draw Reason Code                             A           3
  # DTSUNN      DT Sunday Net Draw                                P           5
  # DTSUNR      DT Sunday Returns                                 P           5+
  # SUNDOK      Draw edit for day allowed?                        A           1
  # SUNROK      Returns edit for day allowed?                     A           1
  # SUNDTP      Publication Day Type                              A           1
  # SUNZDR      Zero Draw Reason Code                             A           3
  # LRTNWK      indicates if a LR should be displayed Y/N         A           1
  # UDTUSR      Last Changed User                                 A           10
  # UDTDAT      Last Changed Date                                 P           6
  # UDTTIM      User/Date/Time Time                               P           6
  # UDTPRC      Last Changed Process                              A           10
  # UDTFNC      Last Changed Function                             A           7
  # UDTDATVIR   Last Changed Date (YYYYMMDD)                      P           8

  self.table_name = 'wpdrww'
  #[TODO] Move establish_connection to abstract class ChampionTable
  self.establish_connection :champion
  self.primary_keys = :eadrs, :mktid, :dstid, :rteid, :locid, :poid

  belongs_to :route_location, foreign_key: [:eadrs, :mktid, :dstid, :rteid, :locid],
                              primary_key: [:eadrs, :mktid, :dstid, :rteid, :locid]
  belongs_to :product, foreign_key: :prodid, primary_key: :prodid
  belongs_to :web_portal_route, foreign_key: [:eadrs, :mktid, :dstid, :rteid],
                                primary_key: [:eadrs, :mktid, :dstid, :rteid]
  has_many :location_draw_return_errors, foreign_key: [:eadrs, :mktid, :dstid, :rteid, :locid, :poid],
                                         primary_key: [:eadrs, :mktid, :dstid, :rteid, :locid, :poid]

  scope :join_product, -> {
    joins(:product)
    .select('wpdrww.*, prod.prodrd as product_short_name')
  }

  scope :distinct_product, -> {
    select("prod.prodid, prod.prodrd")
    .joins(:product)
    .distinct
  }

  scope :ordered_by_prod_seq, -> { order(poseq: :asc) }
  scope :product_totals, -> {
    select("wpdrww.eadrs, wpdrww.mktid, wpdrww.dstid, wpdrww.rteid, wpdrww.prodid,
        SUM(CASE WHEN dtmonn < 0 THEN 0 ELSE dtmonn END) as dtmonn,
        SUM(CASE WHEN dtmonr < 0 THEN 0 ELSE dtmonr END) as dtmonr,
        SUM(CASE WHEN dttuen < 0 THEN 0 ELSE dttuen END) as dttuen,
        SUM(CASE WHEN dttuer < 0 THEN 0 ELSE dttuer END) as dttuer,
        SUM(CASE WHEN dtwedn < 0 THEN 0 ELSE dtwedn END) as dtwedn,
        SUM(CASE WHEN dtwedr < 0 THEN 0 ELSE dtwedr END) as dtwedr,
        SUM(CASE WHEN dtthrn < 0 THEN 0 ELSE dtthrn END) as dtthrn,
        SUM(CASE WHEN dtthrr < 0 THEN 0 ELSE dtthrr END) as dtthrr,
        SUM(CASE WHEN dtfrin < 0 THEN 0 ELSE dtfrin END) as dtfrin,
        SUM(CASE WHEN dtfrir < 0 THEN 0 ELSE dtfrir END) as dtfrir,
        SUM(CASE WHEN dtsatn < 0 THEN 0 ELSE dtsatn END) as dtsatn,
        SUM(CASE WHEN dtsatr < 0 THEN 0 ELSE dtsatr END) as dtsatr,
        SUM(CASE WHEN dtsunn < 0 THEN 0 ELSE dtsunn END) as dtsunn,
        SUM(CASE WHEN dtsunr < 0 THEN 0 ELSE dtsunr END) as dtsunr")
    .group("wpdrww.eadrs, wpdrww.mktid, wpdrww.dstid, wpdrww.rteid, wpdrww.prodid")
  }
  scope :sum_totals, -> {
    select("wpdrww.eadrs, wpdrww.mktid, wpdrww.dstid, wpdrww.rteid,
        SUM(CASE WHEN dtmonn < 0 THEN 0 ELSE dtmonn END) as dtmonn,
        SUM(CASE WHEN dtmonr < 0 THEN 0 ELSE dtmonr END) as dtmonr,
        SUM(CASE WHEN dttuen < 0 THEN 0 ELSE dttuen END) as dttuen,
        SUM(CASE WHEN dttuer < 0 THEN 0 ELSE dttuer END) as dttuer,
        SUM(CASE WHEN dtwedn < 0 THEN 0 ELSE dtwedn END) as dtwedn,
        SUM(CASE WHEN dtwedr < 0 THEN 0 ELSE dtwedr END) as dtwedr,
        SUM(CASE WHEN dtthrn < 0 THEN 0 ELSE dtthrn END) as dtthrn,
        SUM(CASE WHEN dtthrr < 0 THEN 0 ELSE dtthrr END) as dtthrr,
        SUM(CASE WHEN dtfrin < 0 THEN 0 ELSE dtfrin END) as dtfrin,
        SUM(CASE WHEN dtfrir < 0 THEN 0 ELSE dtfrir END) as dtfrir,
        SUM(CASE WHEN dtsatn < 0 THEN 0 ELSE dtsatn END) as dtsatn,
        SUM(CASE WHEN dtsatr < 0 THEN 0 ELSE dtsatr END) as dtsatr,
        SUM(CASE WHEN dtsunn < 0 THEN 0 ELSE dtsunn END) as dtsunn,
        SUM(CASE WHEN dtsunr < 0 THEN 0 ELSE dtsunr END) as dtsunr")
    .group("wpdrww.eadrs, wpdrww.mktid, wpdrww.dstid, wpdrww.rteid")
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
  alias_attribute :product_order_draw_threshold_max,  :podmax
  alias_attribute :monday_net_draw,                   :dtmonn
  alias_attribute :monday_returns,                    :dtmonr
  alias_attribute :monday_draw_edit_allowed,          :mondok
  alias_attribute :monday_returns_edit_allowed,       :monrok
  alias_attribute :monday_publication_day_type,       :mondtp
  alias_attribute :monday_zero_draw_reason_code,      :monzdr
  alias_attribute :tuesday_net_draw,                  :dttuen
  alias_attribute :tuesday_returns,                   :dttuer
  alias_attribute :tuesday_draw_edit_allowed,         :tuedok
  alias_attribute :tuesday_returns_edit_allowed,      :tuerok
  alias_attribute :tuesday_publication_day_type,      :tuedtp
  alias_attribute :tuesday_zero_draw_reason_code,     :tuezdr
  alias_attribute :wednesday_net_draw,                :dtwedn
  alias_attribute :wednesday_returns,                 :dtwedr
  alias_attribute :wednesday_draw_edit_allowed,       :weddok
  alias_attribute :wednesday_returns_edit_allowed,    :wedrok
  alias_attribute :wednesday_publication_day_type,    :weddtp
  alias_attribute :wednesday_zero_draw_reason_code,   :wedzdr
  alias_attribute :thursday_net_draw,                 :dtthrn
  alias_attribute :thursday_returns,                  :dtthrr
  alias_attribute :thursday_draw_edit_allowed,        :thrdok
  alias_attribute :thursday_returns_edit_allowed,     :thrrok
  alias_attribute :thursday_publication_day_type,     :thrdtp
  alias_attribute :thursday_zero_draw_reason_code,    :thrzdr
  alias_attribute :friday_net_draw,                   :dtfrin
  alias_attribute :friday_returns,                    :dtfrir
  alias_attribute :friday_draw_edit_allowed,          :fridok
  alias_attribute :friday_returns_edit_allowed,       :frirok
  alias_attribute :friday_publication_day_type,       :fridtp
  alias_attribute :friday_zero_draw_reason_code,      :frizdr
  alias_attribute :saturday_net_draw,                 :dtsatn
  alias_attribute :saturday_returns,                  :dtsatr
  alias_attribute :saturday_draw_edit_allowed,        :satdok
  alias_attribute :saturday_returns_edit_allowed,     :satrok
  alias_attribute :saturday_publication_day_type,     :satdtp
  alias_attribute :saturday_zero_draw_reason_code,    :satzdr
  alias_attribute :sunday_net_draw,                   :dtsunn
  alias_attribute :sunday_returns,                    :dtsunr
  alias_attribute :sunday_draw_edit_allowed,          :sundok
  alias_attribute :sunday_returns_edit_allowed,       :sunrok
  alias_attribute :sunday_publication_day_type,       :sundtp
  alias_attribute :sunday_zero_draw_reason_code,      :sunzdr
  alias_attribute :week_late_returns,                 :lrtnwk
  alias_attribute :change_user,                       :udtusr
  alias_attribute :change_date,                       :udtdat
  alias_attribute :user_date_time,                    :udttim
  alias_attribute :last_changed_process,              :udtprc
  alias_attribute :last_changed_function,             :udtfnc
  alias_attribute :last_changed_date,                 :udtdatvir

  attr_accessor :modified
  attr_accessor :monday_update_type
  attr_accessor :tuesday_update_type
  attr_accessor :wednesday_update_type
  attr_accessor :thursday_update_type
  attr_accessor :friday_update_type
  attr_accessor :saturday_update_type
  attr_accessor :sunday_update_type
  attr_accessor :week_end_date

  validates :monday_returns,
            :tuesday_returns,
            :wednesday_returns,
            :thursday_returns,
            :friday_returns,
            :saturday_returns,
            :sunday_returns,
            returns: true

  validates :monday_net_draw,
            :tuesday_net_draw,
            :wednesday_net_draw,
            :thursday_net_draw,
            :friday_net_draw,
            :saturday_net_draw,
            :sunday_net_draw,
            draw: true

  # remove blanks form  values
  def to_param
    super.delete(' ')
  end

  # initialize virtual attributes
  after_find do |record|
    record.monday_update_type = "N"
    record.tuesday_update_type = "N"
    record.wednesday_update_type = "N"
    record.thursday_update_type = "N"
    record.friday_update_type = "N"
    record.saturday_update_type = "N"
    record.sunday_update_type = "N"
  end

  # check if record was modified
  def self.modified?(record)
    record.values_at(:monday_update_type, :tuesday_update_type, :wednesday_update_type,
                     :thursday_update_type, :friday_update_type, :saturday_update_type,
                     :sunday_update_type)
          .any? { |value| !(value == "N" || value.blank?) }
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
    record = LocationDrawReturnUpdate.new(attributes_to_update)
    record.save(validate: false)
  end

  def week_late_returns?
    return self.week_late_returns == 'Y'
  end

  private

    # Get a hash of attributes for updating
    def attributes_to_update
      attributes.slice(
        "eadrs", "mktid", "dstid", "rteid", "locid", "poid",
        "dtmonn", "dtmonr", "monzdr", "dttuen", "dttuer", "tuezdr",
        "dtwedn", "dtwedr", "wedzdr", "dtthrn", "dtthrr", "thrzdr",
        "dtfrin", "dtfrir", "frizdr", "dtsatn", "dtsatr", "satzdr",
        "dtsunn", "dtsunr", "sunzdr"
      ).merge(
        monday_update_type: monday_update_type,
        tuesday_update_type: tuesday_update_type,
        wednesday_update_type: wednesday_update_type,
        thursday_update_type: thursday_update_type,
        friday_update_type: friday_update_type,
        saturday_update_type: saturday_update_type,
        sunday_update_type: sunday_update_type,
        week_end_date: week_end_date
      )
    end
end
