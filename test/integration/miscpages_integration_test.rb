# require "test_helper"

# class MiscpagesIntegrationTest < ActionDispatch::IntegrationTest
#   def test_terms_of_service
#     get miscpage_url(id: 'terms_of_service')
#     assert_response :success
#     assert_includes @response.body, 'Terms of Service'
#   end

#   def test_faq
#     get miscpage_url(id: 'faq')
#     assert_response :success
#     assert_select "h1", "FAQS"
#   end

#   def test_contactus
#     get miscpage_url(id: 'contactus')
#     assert_response :success
#     assert_select "h1", "CONTACT US PAGE"
#   end

#   def test_info
#     get miscpage_url(id: 'info')
#     assert_response :success
#     assert_select "h1", "INFORMATION PAGE"
#   end

# end
