# Sample Service Call
# lansa_service = 'SCDM_SIGNON'
# lansa_query = {"SESSID":"new","EADRS":"old","WPPASS":"older","SITEID":"CHAMP"}
# LansaIntegratorService.new(service: lansa_service,
#     query: lansa_query).call
# Or
# lansa_service = 'SCDM_FPWD'
# lansa_query = {"EADRS":"tests@test.com","SITEID":"CHAMP"}
# LansaIntegratorService.new(service: lansa_service,
#     query: lansa_query).call

class LansaIntegratorService
  include HTTParty

  def initialize(params)
    @service = params[:service]
    @query = params[:query]
    @response_struct =  OpenStruct.new
  end

  def call()
    response = make_lansa_call(@service, @query)
    fill_struct(response) if response.success?
  end

  # private
  attr_reader :query
  attr_reader :service
  attr_reader :response_struct

  def make_lansa_call(service, query)
    begin
      HTTParty.post(make_complete_url(service),
        :headers => {'Content-Type'=>'application/json'},
        :body => @query.to_json, timeout: 4)
      rescue Net::ReadTimeout
        httparty_req = HTTParty::Request.new Net::HTTP::Get, '/'
        nethttp_resp = Net::HTTPInternalServerError.new('1.1', 500, 'Internal Server Error')
        HTTParty::Response.new(httparty_req, nethttp_resp, lambda {''}, body: '')
    end

    # Never get this to work. always returns a port 80 closed so just go with what's above
    # self.class.post(service, :headers => {'Content-Type'=>'application/json'},
    #   body: query.to_json)
  end

  def make_complete_url(service)
    base_uri =  LANSA_INTEGRATOR_URL + service
  end

  def fill_struct(response)
    if response.nil?
      @response_struct.success =  false
    else
      @response_struct.success = response.ok?
      response.parsed_response.each{ |x,y| @response_struct[x.to_sym] = y } if response.response.class == Net::HTTPOK
      @response_struct
    end
  end
end
