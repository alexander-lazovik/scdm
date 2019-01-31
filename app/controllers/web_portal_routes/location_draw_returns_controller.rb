class WebPortalRoutes::LocationDrawReturnsController < ApplicationController
  include UserConcerns
  before_action :logged_in_user
  before_action :set_location_draw_returns, only: [:edit]

  def edit
    respond_to do |format|
      format.html
      format.xlsx do
        response.headers["Content-Disposition"] = "attachment; filename=\"weekly_draw_return_#{@web_portal_route.route_id}.xlsx\""
      end
    end
  end

  def update
    load_route
    change_records
    if save_records
      redirect_to edit_draw_and_return_path(id: params[:id], range: params[:range]),
        notice: "Weekly Returns and Draw have been updated successfully."
    else
      flash.now[:alert] = "Errors in records prohibited this data from being saved"
      render action: "update", locals: { errors: errors_to_json }
    end
  end

  private

    def change_records
      @records = []
      location_draw_returns = params.fetch(:location_draw_returns, {})
      location_draw_returns.each do |key, value|
        record = LocationDrawReturn.change(key, location_draw_return_params(value))
        @records << record if record
      end
    end

    def validate_records
      @invalid_records = @records.select(&:invalid?)
      @invalid_records.empty?
    end

    def errors_to_json
      @records.each_with_object({}) { |r, hash| hash[r.to_param] = r.errors.messages if r.errors.any? }.to_json
    end

    def save_records
      return true if @records.empty?
      return false unless validate_records

      @web_portal_route.clear_route if @web_portal_route
      saved = @records.all? { |record| record.save }
      call_update_service if saved
    end

    def call_update_service
      lansa_query = update_draw_returns_json(@web_portal_route)
      lansa_result = LansaIntegratorService.new(service: "SCDM_CDRW", query: lansa_query).call
      result = lansa_result && lansa_result.success && lansa_result.wperror == "N" && lansa_result.wpscdmp == "Y"
      translate_lansa_errors if lansa_result && lansa_result.wperror == "Y"
      result
    end

    def translate_lansa_errors
      @records.each do |record|
        record.location_draw_return_errors.each do |error|
          field = record.has_attribute?(error.error_field) ? error.error_field : :base
          record.errors.add(field, error.error_message.rstrip)
          @invalid_records << record
        end
      end
    end

    def load_route
      @web_portal_route = WebPortalRoute.find(params[:id])
      @web_portal_route.week_end_date = params[:range].blank? ? Date.today() : param_to_date(params[:range])
      @web_portal_route.week_end_date = @web_portal_route.week_end_date.end_of_week
      @locations = @web_portal_route.locations
    end

    def load_draw_returns
      return unless @web_portal_route
      json_query = get_draw_and_returns_on_route_json(@web_portal_route)
      @results = LansaIntegratorService.new(service: 'SCDM_CDWK', query: json_query).call
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_location_draw_returns
      load_route
      load_draw_returns
      @zero_draw_reason_codes = ZeroDrawReasonCode.all
    end

    def location_draw_return_params(record)
      record.permit(
        :email_address, :market_id, :district_id, :route_id, :location_id, :product_order_id, :week_end_date,
        :monday_net_draw, :monday_returns, :monday_zero_draw_reason_code, :monday_update_type,
        :tuesday_net_draw, :tuesday_returns, :tuesday_zero_draw_reason_code, :tuesday_update_type,
        :wednesday_net_draw, :wednesday_returns, :wednesday_zero_draw_reason_code, :wednesday_update_type,
        :thursday_net_draw, :thursday_returns, :thursday_zero_draw_reason_code, :thursday_update_type,
        :friday_net_draw, :friday_returns, :friday_zero_draw_reason_code, :friday_update_type,
        :saturday_net_draw, :saturday_returns, :saturday_zero_draw_reason_code, :saturday_update_type,
        :sunday_net_draw, :sunday_returns, :sunday_zero_draw_reason_code, :sunday_update_type, :modified
      ).merge(week_end_date: date_to_champion(@web_portal_route.week_end_date))
    end
end

