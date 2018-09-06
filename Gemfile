source 'https://rubygems.org'

ruby '2.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7'

# Use mysql2 in production
gem 'mysql2', '~> 0.4.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Battle.net API calls
gem 'httparty'

# Newrelic monitoring
gem 'newrelic_rpm'

# Cors support
gem 'rack-cors', :require => 'rack/cors'

# Can Can for Authorization
gem 'cancan'

# Omniauth-Bnet for Authentication
gem 'omniauth-bnet'

group :development, :test do
  # Use Thin for development
  gem 'thin'

  # Use sqlite3 in development
  gem 'sqlite3'

  # Use Capistrano for deployment
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
  gem 'capistrano-bundler'
  gem 'capistrano-chruby'

  # Guard
  gem 'guard-rspec', require: false
  gem 'rb-readline'

  # Docs
  gem 'hanna-nouveau', require: false
end

group :test do
  # Use rspec for testing
  gem 'rspec-rails'

  # Code Coverage
  gem 'simplecov', require: false
  gem "codeclimate-test-reporter", require: false

  # Database Cleaning
  gem 'database_cleaner'

  # API Testing
  gem 'rack-test', require: "rack/test"
  gem 'json_spec'

  # Mocking Net Requests
  gem 'webmock'
  gem 'vcr'

  # Factories
  gem 'factory_girl_rails'
end
