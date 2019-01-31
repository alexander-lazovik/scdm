case Rails.env
when 'test', 'development', 'staging'
  LANSA_INTEGRATOR_URL = 'http://stub'
end
