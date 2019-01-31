class WebPortalRoutes::PrintDrawReturnsController < ApplicationController

  include UserConcerns
  before_action :logged_in_user
  before_action :set_location_draw_and_returns, only: [:show]

  def show
    pdf = LocationDrawReturnsPdf.new(@portal_user, @web_portal_route, @locations)
    send_data pdf.render, filename: "draw_return_#{@web_portal_route.route_id}",
                              type: "application/pdf",
                              disposition: "inline"
  end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_location_draw_and_returns
      @portal_user = current_user
      @web_portal_route = WebPortalRoute.find(params[:id])

      @web_portal_route.week_end_date = params[:range].blank? ? Date.today() : Date.strptime(params[:range], '%m/%d/%Y')
      @web_portal_route.week_end_date = @web_portal_route.week_end_date + (7 - @web_portal_route.week_end_date.cwday) unless @web_portal_route.week_end_date.cwday == 7

      if @portal_user.valid? && @web_portal_route.valid?
        json_query = get_draw_and_returns_on_route_json(@web_portal_route)
        @results = LansaIntegratorService.new(service: 'SCDM_CDWK', query: json_query).call
        @locations = @web_portal_route.locations
      end

      @zero_draw_reason_codes = ZeroDrawReasonCode.all
    end

end

