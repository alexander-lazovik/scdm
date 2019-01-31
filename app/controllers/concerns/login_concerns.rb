module LoginConcerns

  def create_sign_on_json(login_user)
  {
    "sessid":"#{login_user.session_id.strip}",
    "eadrs":"#{login_user.email_address.strip}",
    "wppass":"#{login_user.password}"
  }
  end

  def create_forgot_password_json(login_user)
  {
    "eadrs":"#{login_user.email_address.strip}",
    "siteid":"CHAMP"
  }
  end

end


