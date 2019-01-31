AppStatus::ResourceCollection.configure do |c|

  # the block passed to `add_dependency` should return `true` if the service is up and `false` if it is down.  Here are some examples...
#  c.add_dependency('Lansa Integrator') do
#    begin
#      lansa_service = 'SCDM_FPWD'
#      lansa_query = {"EADRS":"tests@test.com","SITEID":"CHAMP"}
#
#      results = LansaIntegratorService.new(service: lansa_service, query: lansa_query).call
#      results[:success]
#    rescue
#      false
#    end
#  end

  c.add_dependency('Can Reach Champion') do
    begin
      PortalUser.first
      true
    rescue
      false
    end
  end

  # c.add_dependency('some API') do
  #   response = HTTParty.get('some URL')
  #   response.code == 200
  # end

  # # adding a duration for which to cache the block result...
  # c.add_dependency('some API', expires_in: 5.minutes) do
  #   response = HTTParty.get('some URL')
  #   response.code == 200
  # end

end
