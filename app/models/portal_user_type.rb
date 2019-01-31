class PortalUserType <  ActiveRecord::Base

  # Field     Description                                 Type        Len Dec
  # SESSID    WP Session ID                               A           25
  # EADRS     Electronic Address                          A           50
  # ASGTYP    WP Assignment Type ID   (RTE or BCP)        A           3
  # EMLREM    WP Email Reminder Flag (Y or N)             A           1
  # SCHCOD    Schedule Code (for BCP only DAILY or blank) A           8
  # UDTUSR    Last Changed User                           A           10
  # UDTDAT    Last Changed                                Date        P   6
  # UDTTIM    User/Date/Time                              Time        P   6
  # UDTPRC    Last Changed Process                        A           10
  # UDTFNC    Last Changed Function                       A           7
  # UDTDATVIR Last Changed Date                           (YYYYMMDD)  P 8

  self.table_name = 'wpuass'
  self.establish_connection :champion
  self.primary_keys = :sessid, :asgtyp
  belongs_to :portal_user, foreign_key: :sessid, primary_key: :sessid

end
