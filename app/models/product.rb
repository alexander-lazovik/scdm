class Product <  ActiveRecord::Base
  self.table_name = 'prod'
  self.establish_connection :champion unless Rails.env.test?
  self.primary_key = 'prodid'

  alias_attribute :id,                  :prodid
  alias_attribute :product_description, :prodnm
  alias_attribute :product_short_name,  :prodrd
  alias_attribute :monday_delivery,     :mondpb
  alias_attribute :tuesday_delivery,    :tuedpb
  alias_attribute :wednesday_delivery,  :weddpb
  alias_attribute :thursday_delivery,   :thrdpb
  alias_attribute :friday_delivery,     :fridpb
  alias_attribute :saturday_delivery,   :satdpb
  alias_attribute :sunday_delivery,     :sundpb
end
