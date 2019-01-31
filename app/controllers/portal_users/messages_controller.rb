class PortalUsers::MessagesController < ApplicationController
  include UserConcerns
  before_action :logged_in_user
  layout 'login'

  def index
    @portal_user = current_user
    @messages = @portal_user.messages
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:email_address, :market_id, :district_id,
        :route_id, :id, :message_text, :last_changed_user, :last_changed_date,
        :user_date_time, :last_changed_process, :last_changed_function,
        :last_changed_date
        )
    end

end
