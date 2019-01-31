class WebPortalRoutes::RdlDrawReturnsController < ApplicationController
  include UserConcerns
  before_action :logged_in_user
  before_action :set_rdl_draw_returns, only: [:edit]

  def edit
  end

  def update
    load_route
    change_records
    if save_records
      redirect_to edit_rdl_draw_and_return_path(id: params[:id], range: params[:range]),
        notice: "RDL Returns and Draw have been updated successfully."
    else
      flash.now[:alert] = "Errors in records prohibited this data from being saved"
      render action: "update", locals: { errors: errors_to_json }
    end
  end

  private

    def change_records
      @records = []
      rdl_draw_returns = params.fetch(:rdl_draw_returns, {})
      rdl_draw_returns.each do |key, value|
        record = RdlDrawReturn.change(key, rdl_draw_return_params(value))
        @records << record if record
      end
    end

    def validate_records
      @records.select(&:invalid?).empty?
    end

    def errors_to_json
      @records.each_with_object({}) { |r, hash| hash[r.to_param] = r.errors.messages if r.errors.any? }.to_json
    end

    def save_records
      return true if @records.empty?
      return false unless validate_records

      @web_portal_route.clear_rdl if @web_portal_route
      saved = @records.all? { |record| record.save }
      call_update_service if saved
    end

    def call_update_service
      lansa_query = update_rdl_draw_returns_json(@web_portal_route)
      lansa_result = LansaIntegratorService.new(service: "SCDM_RDLU", query: lansa_query).call
      result = lansa_result && lansa_result.success && lansa_result.wperror == "N" && lansa_result.wpscdmp == "Y"
      translate_lansa_errors if lansa_result && lansa_result.wperror == "Y"
      result
    end

    def translate_lansa_errors
      @records.each do |record|
        record.rdl_draw_return_errors.each do |error|
          field = record.has_attribute?(error.error_field) ? error.error_field : :base
          record.errors.add(field, error.error_message.rstrip)
        end
      end
    end

    def load_route
      @web_portal_route = WebPortalRoute.find(params[:id])
      @web_portal_route.distribution_date = params[:range].blank? ? Date.today() : param_to_date(params[:range])
      @locations = @web_portal_route.rdl_locations
    end

    def load_draw_returns
      return unless @web_portal_route
      json_query = rdl_draw_returns_json(@web_portal_route)
      LansaIntegratorService.new(service: 'SCDM_DRDL', query: json_query).call
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_rdl_draw_returns
      load_route
      load_draw_returns
      @zero_draw_reason_codes = ZeroDrawReasonCode.all
    end

    def rdl_draw_return_params(record)
      record.permit(:email_address, :market_id, :district_id, :route_id, :location_id,
        :product_order_id, :product_order_sequence, :product_id,
        :day_net_draw, :day_returns, :day_zero_draw_reason_code, :day_update_type, :modified)
    end
end

