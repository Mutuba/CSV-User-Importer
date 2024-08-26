# frozen_string_literal: true

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/cassettes"
  config.hook_into(:webmock)
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :new_episodes }

  config.allow_http_connections_when_no_cassette = true
  config.ignore_request do |request|
    URI(request.uri).port == 9515
  end
end

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
