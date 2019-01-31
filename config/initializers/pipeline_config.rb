Pipeline.configure do |config|
  # config.deployment_yamls << 'docker-files/cron-deployment.yml'
  # config.deployment_yamls << 'docker-files/bg-deployment.yml'
end

Pipeline::Configuration::ENV['lb_role_id'] = {
  development: 19854,
  staging: 22531,
  production_east: 22530,
  production_west: 22680
}
