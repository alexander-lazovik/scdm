# require 'test_helper'

# class LoginUserTest < ActiveSupport::TestCase

#   def setup
#     @login_user = LoginUser.new(
#       email_address: 'JZORNES@REPUBLICMEDIA.COM',
#       password: 'PassW0rd',
#       sessionId: 'alsdjgfsaoihgj'
#       )
#   end

#   test 'valid login user' do
#     assert @login_user.valid?, 'Is a valid Login User'

#   end

#   test 'invalid without email' do
#     @login_user.email_address = nil
#     refute @login_user.valid?, 'Must have an email to log in'
#     assert_not_nil @login_user.errors[:email_address], 'no validation error for email_address present'

#   end

#   test 'invalid email_address not allowed' do
#     login_user = LoginUser.new(
#           email_address: 'snfiofn',
#           password: 'PassW0rd',
#           sessionId: 'alsdjgfsaoihgj'
#           )
#     refute login_user.valid?, 'Must have a email valid email address to log in'
#     assert_not_nil login_user.errors[:email_address], 'no validation error for email_address present'

#   end

#   test 'can validate email address' do
#     login_user = LoginUser.new(
#           email_address: 'abc@test.com',
#           password: 'PassW0rd',
#           sessionId: 'alsdjgfsaoihgj'
#           )
#     assert login_user.valid?, 'Must have a email valid email address to log in'
#   end

#   test 'can uppercase email addresses for suibmission to Champion' do
#     login_user = LoginUser.new(
#           email_address: 'abc@test.com',
#           password: 'PassW0rd',
#           sessionId: 'alsdjgfsaoihgj'
#           )
#     assert login_user.email_address == 'ABC@TEST.COM', 'Must have a email valid email address to log in'
#   end

#   test 'can successfully login' do

#     stub_request(:post, "http://tinman.midrange.gci/api/v1/SCDM_SIGNON").
#       to_return(status: 200, body: {"wppswdok":"Y","eadrs":"JZORNES@REPUBLICMEDIA.COM","wppass":"PassW0rd","sessid":"fd35e078f3eeec48a216f538","wpscdmp":"Y","wpactive":"Y"}.to_json, headers: {"Content-Type"=> "application/json"})

#     login_user = LoginUser.new(
#           email_address: 'abc@test.com',
#           password: 'PassW0rd',
#           sessionId: 'alsdjgfsaoihgj'
#           )


#      assert login_user.login?

#   end

# end
