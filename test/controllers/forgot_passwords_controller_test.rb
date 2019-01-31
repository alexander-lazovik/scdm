# require 'test_helper'

# class ForgotPasswordsControllerTest < ActionController::TestCase

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


#   test "should get new forgot Password" do
#     get 'new'
#     assert_response :success
#   end

#   test "creates forgot password request " do

#     post 'create', { login_user: { email_address: @valid_user.email_address, sessionId: @valid_user.sessionId, password: @valid_user.password} }
#     assert_redirected_to login_path
#   end

# end
