# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.10'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5'
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '~> 3.3.7'
gem 'bootstrap-datepicker-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'rake', '11.3'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'pry-rails'
  gem 'pry-byebug'

end

group :test do
  gem 'simplecov', :require => false
  gem "minitest-rails"
  gem 'minitest-reporters'
  gem 'webmock'
  gem 'mocha'

end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 2.0'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'guard'
  gem 'guard-minitest'
  gem 'terminal-notifier-guard'
  gem 'awesome_print'
  gem "better_errors"
  gem "binding_of_caller"

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# gem 'bootstrap', '~> 4.1.1'

gem 'httparty', ' ~> 0.16'

# connection for ibm odbc
gem 'ibm_db_odbc', '0.8.7'
gem 'gci-simple-encryption'
gem 'composite_primary_keys'


# gems for Docker Deployment
gem 'commerce-pipeline', '3.0.0.pre11'
gem 'commerce-app-status', '1.1.0'
gem 'rails_stdout_logging'

gem 'ransack'

# gems to give us PDF rendering
gem 'prawn', '~> 2.2.2'
gem 'prawn-table'

# gems to export to XLS format
gem 'rubyzip', '>= 1.2.1'
gem 'zip-zip' # will load compatibility for old rubyzip API.
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'axlsx_rails'
