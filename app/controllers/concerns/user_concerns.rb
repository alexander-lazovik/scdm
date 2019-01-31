module UserConcerns

  def create_get_routes_json(portal_user)
    {
      "eadrs": portal_user.eadrs
    }
  end

  def get_draw_and_returns_on_route_json(web_portal_route)
    {
      "eadrs": web_portal_route.eadrs,
      "mktid": web_portal_route.market_id,
      "dstid": web_portal_route.district_id,
      "rteid": web_portal_route.route_id,
      "dwkedt": date_to_champion(web_portal_route.week_end_date)
    }
  end

  # Update User Email & Password Process:
  # The following Lansa fields are expected as parms when the Lansa back-end function is called:
  # SESSID     Session ID       A 25
  # EADRS      Email address    A 50  identifies the user in Champion
  # WPEADRS    New Email Addr   A 50  send existing email addr if not changing
  # WPPASS     New Password     A 10  send existing password if not changing
  def update_email_json(portal_user)
  {
    "sessid": portal_user.sessid.strip,
    "eadrs": portal_user.eadrs.strip,
    "wpeadrs": portal_user.new_email_address.strip,
    "wppass": portal_user.current_password
  }
  end

  def update_password_json(portal_user)
  {
    "sessid": portal_user.sessid.strip,
    "eadrs": portal_user.eadrs.strip,
    "wpeadrs": portal_user.email_address.strip,
    "wppass": portal_user.new_password
  }
  end

  # Update Weekly Draw and Returns process
  # EADRS   Email address   A  50  identifies the user in Champion
  # MKTID   Market ID       N  2
  # DSTID   District ID     N  3
  # RTEID   Route ID        N  3
  # DWKEDT  Week End Date   N  8
  def update_draw_returns_json(web_portal_route)
    {
      "eadrs":  web_portal_route.eadrs,
      "mktid":  web_portal_route.market_id,
      "dstid":  web_portal_route.district_id,
      "rteid":  web_portal_route.route_id,
      "dwkedt": date_to_champion(web_portal_route.week_end_date)
    }
  end

  # convert date parameter from string format MM/DD/YYYY to date
  def param_to_date(val)
    Date.strptime(val, '%m/%d/%Y')
  end

  # convert Date to Champion date format YYYYMMDD
  def date_to_champion(val)
    val.strftime('%Y%m%d')
  end

  # Request Draw by RDL Process
  # EADRS   Email address   A   50
  # MKTID   Market ID       N    2
  # DSTID   District ID     N    3
  # RTEID   Route ID        N    3
  # DDSTDT  Distrib. Date   N    8  YYYYMMDD
  def rdl_draw_returns_json(web_portal_route)
    {
      "eadrs": web_portal_route.eadrs,
      "mktid": web_portal_route.market_id,
      "dstid": web_portal_route.district_id,
      "rteid": web_portal_route.route_id,
      "ddstdt": date_to_champion(web_portal_route.distribution_date)
    }
  end

  # Update RDL Draw & Returns Process
  # EADRS   Email address   A  50  identifies the user in Champion
  # MKTID   Market ID       N  2
  # DSTID   District ID     N  3
  # RTEID   Route ID        N  3
  # DDSTDT  Distrib. Date   N  8
  def update_rdl_draw_returns_json(web_portal_route)
    {
      "eadrs":  web_portal_route.eadrs,
      "mktid":  web_portal_route.market_id,
      "dstid":  web_portal_route.district_id,
      "rteid":  web_portal_route.route_id,
      "ddstdt": date_to_champion(web_portal_route.distribution_date)
    }
  end
end
