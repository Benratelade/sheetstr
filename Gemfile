# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |_repo| "https://github.com/#{repo}.git" }

ruby "3.2.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 7.1.3"
# Use postgresql as the database for Active Record
gem "pg"
# Use Puma as the app server
gem "puma"
# Use SCSS for stylesheets
gem "sass-rails"
# Transpile app-like JavaScript.
gem "jsbundling-rails"
# Handle scss the new way
gem "cssbundling-rails"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
gem "redis"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "devise"

gem "view_component", require: "view_component/engine"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "pry-byebug"

  gem "rspec-rails"

  gem "letter_opener"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "listen"
  gem "rack-mini-profiler"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rake", require: false
  gem "solargraph", require: false
  gem "spring"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara"
  gem "capybara-screenshot"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"

  # For more descriptive tests
  gem "rails-controller-testing"
  gem "rspec-activemodel-mocks"
  gem "rspec-example_steps"
  gem "rspec_junit_formatter"

  gem "timecop"

  gem "factory_bot_rails"

  gem "rspec-wait"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
