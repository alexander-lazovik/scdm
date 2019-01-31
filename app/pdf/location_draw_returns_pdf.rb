# PDF renderer for the draws and returns by location
class LocationDrawReturnsPdf < Prawn::Document
  include ChampionHelper
  def initialize(portal_user, web_portal_route, locations)
    super(top_margin: 70, page_layout: :landscape)
    @portal_user = portal_user
    @web_portal_route = web_portal_route
    @locations = locations
    week_to_from
    route_info
    draws_and_returns
    draws_totals
    draws_and_ret_totals
  end

  def week_to_from
    text "Draw Management for the Week of #{(@web_portal_route.week_end_date - 6).strftime('%m/%d/%Y')} to #{@web_portal_route.week_end_date.strftime('%m/%d/%Y')}"
  end

  def route_info
    move_down 10
    text "Market ID - #{@web_portal_route.market_id} District ID - #{@web_portal_route.district_id} Route - #{@web_portal_route.route_id}"
  end

  def draws_and_returns
    move_down 20
    table draws_and_returns_rows  do
      cells.font_size = 6
      row(0).font_style = :bold
      columns(1..9).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end

  end
  def draws_totals
    move_down 10
    text "Draw and Returns Totals"
  end

  def draws_and_ret_totals
    move_down 20
    table draws_and_ret_tot_rows  do
      cells.font_size = 6
      row(0).font_style = :bold
      columns(0..7).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end

  end
  def draws_and_ret_tot_rows
    [["Prod Type",
      {content: "Monday",     colspan: 2},
      {content: "Tuesday",    colspan: 2},
      {content: "Wednesday",  colspan: 2},
      {content: "Thursday",   colspan: 2},
      {content: "Friday",     colspan: 2},
      {content: "Saturday",   colspan:2},
      {content: "Sunday",     colspan: 2}]] +
    draws_and_ret_tot_data
  end

  def draws_and_returns_rows
    [["Location",
      " ID ",
      "Prod Type",
      {content: "Mon" + "\n" + "#{(@web_portal_route.week_end_date - 6).strftime('%m/%d')}" + "\n" + "Draw Ret", colspan: 2},
      {content: "Tue" + "\n" + " #{(@web_portal_route.week_end_date - 5).strftime('%m/%d')}" + "\n" + "Draw Ret", colspan: 2},
      {content: "Wed" + "\n" + " #{(@web_portal_route.week_end_date - 4).strftime('%m/%d')}" + "\n" + "Draw Ret", colspan: 2},
      {content: "Thur" + "\n" + " #{(@web_portal_route.week_end_date - 3).strftime('%m/%d')}" + "\n" + "Draw Ret", colspan: 2},
      {content: "Fri" + "\n" + " #{(@web_portal_route.week_end_date - 2).strftime('%m/%d')}" + "\n" + "Draw Ret", colspan: 2},
      {content: "Sat" + "\n" + " #{(@web_portal_route.week_end_date - 1).strftime('%m/%d')}" + "\n" + "Draw Ret", colspan: 2},
      {content: "Sun" + "\n" + " #{(@web_portal_route.week_end_date - 6).strftime('%m/%d/%Y')}" + "\n" + "Draw Ret", colspan: 2}]] +
    draws_and_returns_data

  end

  def draws_and_returns_data
    data = []
    prv_id = ""
    @locations.ordered_by_sequence.each do |location|
      location.draws_and_returns.join_product.ordered_by_prod_seq.each do |draw_by_product|
        loc_name = "#{location.id.to_s.strip}"+" - "+"#{location.location_name.strip}"+"\n"+"#{location.address_line.strip}"+"\n #{format_to_phone_number(location.location_phone)}"
        loc_id = "#{location.id}"
        if prv_id == loc_id then
          loc_name = ""
        else
          prv_id = loc_id
        end
        data = data +
        [[loc_name,
          "#{draw_by_product.product_order_id}",
          "#{draw_by_product.product_id}",
          "#{draw_by_product.monday_net_draw}",
          " ",
          "#{draw_by_product.tuesday_net_draw}",
          " ",
          "#{draw_by_product.wednesday_net_draw}",
          " ",
          "#{draw_by_product.thursday_net_draw}",
          " ",
          "#{draw_by_product.friday_net_draw}",
          " ",
          "#{draw_by_product.saturday_net_draw}",
          " ",
           "#{draw_by_product.sunday_net_draw}",
          " "]]
      end
    end
    data
  end

  def draws_and_ret_tot_data
    data = []
    @web_portal_route.draws_and_returns.product_totals.each do |route_product|
        data = data +
        [["#{route_product.prodid.strip}",
          "#{route_product.monday_net_draw}",
          "#{route_product.monday_returns}",
          "#{route_product.tuesday_net_draw}",
          "#{route_product.tuesday_returns}",
          "#{route_product.wednesday_net_draw}",
          "#{route_product.wednesday_returns}",
          "#{route_product.thursday_net_draw}",
          "#{route_product.thursday_returns}",
          "#{route_product.friday_net_draw}",
          "#{route_product.friday_returns}",
          "#{route_product.saturday_net_draw}",
          "#{route_product.saturday_returns}",
          "#{route_product.sunday_net_draw}",
          "#{route_product.sunday_returns}"]]
    end
    data
  end
end
