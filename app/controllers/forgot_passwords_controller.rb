class ForgotPasswordsController < ApplicationController
  include LoginConcerns

  def new
    @login_user = LoginUser.new
  end

  def create
    self.params = params.permit!
    @login_user = LoginUser.new(params['login_user'])
    if @login_user.valid?
      y = create_forgot_password_json(@login_user)
      @login_results = LansaIntegratorService.new(service: 'SCDM_FPWD', query: y).call
      redirect_to login_path, notice: 'It worked!' "Requested information is being Processed"
    else
      flash[:error] = "Please provide a valid email address"
      redirect_to new_forgot_password_path, error: 'Please provide a valid email address'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_login_user
      @login_user = LoginUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def login_user_params
      params.require(:login_user).permit(:session_id, :email_address, :password)
    end
end
