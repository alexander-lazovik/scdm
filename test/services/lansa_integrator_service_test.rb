# require 'test_helper'

# class LansaIntegratorServiceTest < ActiveSupport::TestCase

#   def setup
#     @invalid_user = LoginUser.new(
#       email_address: 'test@tets.com')

#   end

#   test 'can make valid request to Lansa Integrator' do

#   stub_request(:post, "http://tinman.midrange.gci/api/v1/SCDM_FPWD").
#     with(
#       body: "{\"eadrs\":\"TEST@TETS.COM\",\"siteid\":\"CHAMP\"}",
#       headers: {
#       'Content-Type'=>'application/json'
#       }).
#     to_return(status: 200, body: "", headers: {})

#     lansa_service = 'SCDM_FPWD'
#     lansa_query = { "eadrs":"#{@invalid_user.email_address}",
#                     "siteid":"CHAMP"
#                   }

#     results = LansaIntegratorService.new(service: lansa_service,
#      query: lansa_query).call
#     assert results == false, 'Successful Lansa INtegrator call'

#   end

#   test 'can make rescue Lansa Integrator call' do

#   stub_request(:post, "http://tinman.midrange.gci/api/v1/SCDM_SIGNON").
#     with(
#       body: "{\"eadrs\":\"TEST@TETS.COM\",\"siteid\":\"CHAMP\"}",
#       headers: {
#       'Content-Type'=>'application/json'
#       }).
#     to_return(status: 200, body: "", headers: {})


#     lansa_service = 'SCDM_SIGNON'
#     lansa_query = { "eadrs":"#{@invalid_user.email_address}",
#                     "siteid":"CHAMP"
#                   }

#     results = LansaIntegratorService.new(service: lansa_service,
#      query: lansa_query).call

#     assert results == false, 'Successful Lansa INtegrator call'

#   end

# end
