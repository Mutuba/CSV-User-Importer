# frozen_string_literal: true

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"

if Rails.env.production?
  abort("The Rails environment is running in production mode!")
end

require "rspec/rails"
require "sidekiq/testing"
require "database_cleaner"
require "capybara/rails"
require "capybara/rspec"
require "selenium/webdriver"

Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort(e.to_s.strip)
end

if Rails.env.test?
  Sidekiq::Testing.inline!
  RSpec::Sidekiq.configure do |config|
    config.warn_when_jobs_not_processed_by_sidekiq = false
  end
end

RSpec.configure do |config|
  config.include(ActiveJob::TestHelper, type: :model)
  config.include(ActiveJob::TestHelper, type: :controller)
  config.include(ActiveJob::TestHelper, type: :request)
  config.include(ActiveJob::TestHelper, type: :service)
  config.include(ActiveJob::TestHelper, type: :job)

  config.before(:each, type: :system) do
    ActiveJob::Base.queue_adapter = :inline
  end

  config.after(:each, type: :system) do
    ActiveJob::Base.queue_adapter = :test
  end

  config.fixture_paths = [
    Rails.root.join("spec/fixtures"),
  ]
  config.include(Capybara::DSL)
  Capybara.default_driver = :selenium_chrome_headless
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
