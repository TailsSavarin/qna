source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript.
gem 'webpacker', '~> 5.1'
# Turbolinks makes navigating your web application faster.
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease.
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Rubocop, static code analyzer and code formatter.
gem 'rubocop-rails', require: false

# AWS SDK.
gem 'aws-sdk-s3', require: false

# Slim templates generator.
gem 'slim-rails'
# Authentication.
gem 'devise'
# Authorization.
gem 'cancancan'
# Octicons.
gem 'octicons_helper'
# Sending data to js files.
gem 'gon'

# Oauth.
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

# Social buttons.
gem 'bootstrap-social-rails'

# Web fonts and stylesheets
gem 'font-awesome-rails'

# For nested forms.
gem 'cocoon'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # The RSpec testing framework.
  gem 'rspec-rails', '~> 4.0.0'
  # It's a fixtures replacement with a straightforward definition syntax and more.
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background.
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Email Preview
  gem 'letter_opener'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  # ActionMailer and Mail messages testing
  gem 'capybara-email'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  # For RSpec.
  gem 'shoulda-matchers'
  # Tests for controllers
  gem 'rails-controller-testing'
  # For save_and_open_page option
  gem 'launchy'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
