require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.default_cassette_options = {
    allow_unused_http_interactions: false
  }
  config.filter_sensitive_data '<GITHUB_ACCESS_TOKEN>' do
    ENV.fetch "TEST_GITHUB_ACCESS_TOKEN"
  end
  config.configure_rspec_metadata!
end
