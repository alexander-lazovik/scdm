class PortalUsersController < ApplicationController
  include UserConcerns

  before_action :logged_in_user
  before_action :set_portal_user, only: [:show, :edit, :update_email, :update_password]

  # GET /portal_users/1
  # Show user's dashboard instead of profile form
  def show
    if !@portal_user.nil? && @portal_user.has_routes_or_blue_chip('RTE')
      json_query = create_get_routes_json(@portal_user)
      results = LansaIntegratorService.new(service: 'SCDM_CNTR', query: json_query).call
      @portal_user.routes_filled = true if results && results.success == true && results.wpassign == 'Y'
    end
    @messages = @portal_user.messages
    @portal_user.messages_read ||= false
  end

  # Display the user profile
  def edit
    render :edit
  end

  # Update email address
  def update_email
    @portal_user.attributes = portal_user_params

    if @portal_user.valid?(:update_email)
      # Call Lansa service
      @portal_user.new_email_address.upcase!
      lansa_service = "SCDM_WPUS"
      lansa_query = update_email_json(@portal_user)
      lansa_result = LansaIntegratorService.new(service: lansa_service, query: lansa_query).call
      result, lansa_error = check_lansa_result(lansa_result)
    else # show validation errors
      result = :error
      lansa_error = ''
    end

    # re-login the current user behind the scene with the new email address and the current password
    if result == :success
      login_user = LoginUser.new({email_address: @portal_user.new_email_address, password: @portal_user.current_password})
      if login_user.login?
        log_in(login_user)
      else
        log_out
      end
    end

    # Render the result
    respond_to do |format|
      format.js  { render action: "update_email",
                   locals: {result: result, errors: @portal_user.errors.to_json, lansa_error: lansa_error || ''} }
    end
  end

  # Update password
  def update_password
    @portal_user.attributes = portal_user_params

    if @portal_user.valid?(:update_password)
      # Call Lansa service
      lansa_service = "SCDM_WPUS"
      lansa_query = update_password_json(@portal_user)
      lansa_result = LansaIntegratorService.new(service: lansa_service, query: lansa_query).call
      result, lansa_error = check_lansa_result(lansa_result)
    else # show validation errors
      result = :error
    end

    # Render the result
    respond_to do |format|
      format.js  { render action: "update_password",
                   locals: {result: result, errors: @portal_user.errors.to_json, lansa_error: lansa_error || ''} }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_portal_user
    @portal_user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def portal_user_params
    params.require(:portal_user).permit(:new_email_address, :new_email_address_confirmation,
                                        :current_password, :new_password, :new_password_confirmation)
  end

  # Check the result of Lansa call and return the error message if any
  def check_lansa_result(lansa_result)
    if lansa_result.nil? || lansa_result.success == false
      lansa_error = "Lansa Integrator error."
    elsif lansa_result.wperror == 'Y' # error indicator
      msg = @portal_user.portal_user_error
      lansa_error = (msg.nil?) ? "Lansa Integrator: SCDM_WPUS service error." : msg.error_message
    else
      lansa_error = "" # Success
    end
    return [lansa_error.length > 0 ? :failure : :success, lansa_error]
  end

end
