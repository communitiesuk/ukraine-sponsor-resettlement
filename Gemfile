source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.6"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"
# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"
# GOV UK frontend components
gem "govuk-components"
# GOV UK component form builder DSL
gem "govuk_design_system_formbuilder"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.18", ">= 1.18.4", require: false
# GovUK Notify notifications and client
gem "govuk_notify_rails"
# SecureRandom to generate UUIDs
gem "securerandom"

gem "rack-attack"
gem "redis"
gem "sidekiq", "~> 7.3", ">= 7.3.6"

# Sentry - Application Monitoring
gem "sentry-rails"
gem "sentry-ruby"

# S3 & Anti-virus
gem "aws-sdk-s3"
gem "clamby"
gem "ratonvirus"
gem "ratonvirus-clamby"

# Postcode parsing
gem "uk_postcode"

group :development, :test do
  gem "brakeman"
  # Check gems for known vulnerabilities
  gem "bundler-audit"
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "json-schema"
  gem "pry-byebug"
  # Session middleware for testing
  gem "rack_session_access"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "rubocop-govuk", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "scss_lint-govuk"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", "~> 3.3"
  gem "web-console", ">= 4.1.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", require: false
  gem "selenium-webdriver", require: false
  gem "simplecov", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "csv", "~> 3.3"
