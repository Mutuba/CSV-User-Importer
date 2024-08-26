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
