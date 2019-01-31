class NextEdition <  ActiveRecord::Base

  # Field      Description                                   Type  Len Dec
  # DDSTDT     WP Session ID                                   A    25

  self.table_name = 'dctl'
  self.establish_connection :champion unless Rails.env.test?
  self.primary_key = 'ddstdt'

  alias_attribute :next_edition_date, :ddstdt

end

