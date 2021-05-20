source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails'
# Transpile app-like JavaScript
gem 'webpacker', '~> 5.1'
# Turbolinks makes navigating your web application faster
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
gem 'redis-rails'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
# Rubocop, static code analyzer and code formatter
gem 'rubocop-rails', require: false
# AWS
gem 'aws-sdk-s3', require: false
# Slim templates generator
gem 'slim-rails'
# Authentication
gem 'devise'
# Authorizatio
gem 'cancancan'
# Octicons icons
gem 'octicons_helper'
# Sending data to js files
gem 'gon'
# OAuth 2 provider
gem 'doorkeeper', '5.1.1'
# Oauth
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
# Social buttons icons
gem 'bootstrap-social-rails'
# Web fonts and stylesheets
gem 'font-awesome-rails'
# For nested forms
gem 'cocoon'
# Allow generate your JSON in an object-oriented and convention-driven manner
gem 'active_model_serializers', '~> 0.10'
# Provides a minimal two way bridge between the V8 JavaScript engine and Ruby
gem 'mini_racer'
# Setup mysql for sphinx search
gem 'mysql2', '~> 0.5.0', platform: :ruby
# A fast JSON parser and object marshaller
gem 'oj'
# Simple and efficient background processing
gem 'sidekiq', '< 6'
# DSL for web applications
gem 'sinatra', require: false
# Full text search
gem 'thinking-sphinx', '~> 5.0'
# Server settings
gem 'unicorn'
# Provides a clear syntax for writing and deploying cron jobs
gem 'whenever', require: false
# Paginating pages
gem 'will_paginate'
gem 'will_paginate-bootstrap4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # The RSpec testing framework
  gem 'rspec-rails', '~> 4.0.0'
  # It's a fixtures replacement with a straightforward definition syntax and more
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Email Preview
  gem 'letter_opener'
  # Deploy
  gem 'capistrano', require: false
  gem 'capistrano3-unicorn', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  # ActionMailer and Mail messages testing
  gem 'capybara-email'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  # For RSpec
  gem 'shoulda-matchers'
  # Tests for controllers
  gem 'rails-controller-testing'
  # For save_and_open_page option
  gem 'database_cleaner-active_record'
  gem 'launchy'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
