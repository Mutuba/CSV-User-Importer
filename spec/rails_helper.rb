# frozen_string_literal: true

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "sidekiq/testing"
require "database_cleaner"
Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort(e.to_s.strip)
end

Sidekiq::Testing.inline!

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

RSpec.configure do |config|
  config.include(ActiveJob::TestHelper)
  ActiveJob::Base.queue_adapter = :test
  config.fixture_paths = [
    Rails.root.join("spec/fixtures"),
  ]

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
