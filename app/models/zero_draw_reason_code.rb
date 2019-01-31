class ZeroDrawReasonCode <  ActiveRecord::Base
  # Field         Description                                   Type  Len Dec
  # PTCODE
  # PTDESC
  # UPDATE_IDENT

  self.table_name = 'ptzd'
  self.establish_connection :champion unless Rails.env.test?
  self.primary_key = 'ptcode'

  alias_attribute :id,          :ptcode
  alias_attribute :description, :ptdesc
end
