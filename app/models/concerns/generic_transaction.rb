class GenericTransaction < ActiveRecord::Base
  # This file is special. It does not use a sequence for key assignment.
  # The db2odbc_adapter.rb has a special exception for "generic_transactions"
  # so be careful before changing the following table name.

  self.table_name = 'WPAUTH'
  self.establish_connection :champion

  validates_presence_of :function_type, :function_data
  validates_numericality_of :transaction_number, :sequence_number,
                            :last_changed_on, :last_changed_at
  validates_inclusion_of :character_coding, :in => ['', ' ', 'A', 'E']


  def self.get_login_user(sessid)
    # GenericTransaction.find_by_sql("select SESSID, EADRS, WPUNAM, PHNNBR from WPAUTH where SESSID=#{sessid}").first.try(:gecirc)
    GenericTransaction.find_by_sql("select SESSID, EADRS, WPUNAM, PHNNBR from WPAUTH where SESSID=#{sessid}").first
  end

end
