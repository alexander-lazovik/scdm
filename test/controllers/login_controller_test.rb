# require 'test_helper'

# class LoginTest < ActionDispatch::IntegrationTest
#   setup do
#     @invalid_user = LoginUser.new(
#           email_address: 'new@user.com',
#           password: 'PassW0rd',
#           sessionId: 'alsdjgfsaoihgj'
#           )
#   @valid_user = LoginUser.new(
#         email_address: "JZORNES@REPUBLICMEDIA.COM",
#         password: "PassW0rd",
#         sessionId: "ABC1234567890"
#         )
#   end

#   test "should get new login" do
#     get new_login_url
#     assert_response :success
#   end

#   test "fails to create login_user (invalid email/user)" do
#       post login_index_path,  { login_user: { email_address: @invalid_user.email_address, session_id: @invalid_user.session_id, password: @invalid_user.password} }
#     assert_redirected_to root_url, "Invalid users Don't leave Login Page"
#   end

#   test "creates valid login_user " do
#   stub_request(:post, "http://tinman.midrange.gci/api/v1/SCDM_SIGNON").
#     with(
#       body: "{\"sessid\":\"#{@valid_user.session_id}\",\"eadrs\":\"JZORNES@REPUBLICMEDIA.COM\",\"wppass\":\"PassW0rd\"}",
#       headers: {
#       'Content-Type'=>'application/json'
#       }).
#     to_return(status: 200, body: "", headers: {})

#     post login_index_path, { login_user: { email_address: @valid_user.email_address, session_id: @valid_user.session_id, password: @valid_user.password} }
#     assert_redirected_to portal_user_messages_path(@valid_user.session_id), "valid users Routed to messages"
#   end

# end
