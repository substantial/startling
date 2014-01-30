require 'bundler'
Bundler.setup

RSpec.configure do |config|
  config.mock_with :rspec
end

require_relative '../lib/teaching-channel-start'
