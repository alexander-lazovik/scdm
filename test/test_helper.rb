require 'simplecov'
SimpleCov.start 'rails' unless ENV['NO_COVERAGE']

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/reporters'
require 'webmock/minitest'
require 'mocha/minitest'

reporter_options = { color: true }
# Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(:color => true, slow_count: 5 )]
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true, slow_count: 5 )]

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
end
