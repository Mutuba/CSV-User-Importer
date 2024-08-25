# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem "activerecord-import"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"
gem "sidekiq"
gem "sidekiq-status"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"
gem "dotenv-rails"
gem "tzinfo-data"
gem "bundler-audit"
gem "brakeman"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
gem "rubocop-shopify", require: false

group :development do
  gem "annotate"
  gem "web-console"
end

group :test do
  gem "rspec-sidekiq"
  gem 'capybara'
  gem 'selenium-webdriver'
  gem "byebug"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-doc"
  gem "pry-rails"
  gem "rspec"
  gem "rspec-rails"
  gem "rubocop-rails", "~> 2.3"
  gem "shoulda-matchers", "~> 6.0"
  gem "rails-controller-testing"
end
gem "view_component", "~> 3.0"
