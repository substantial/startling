# Startling

## Installation

Add this line to your application's Gemfile:

    gem 'startling'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install startling

## Configuration

Startlingfile.rb or startlingfile.rb should be defined in the root of the project. It can contain a block for configuration:

```ruby
Startling.configure do |config|
  config.wip_limit = 10
  config.repos = <<  "TeachingChannel/teaching-channel-start"
  config.valid_estimates = [1, 2, 3, 5, 8]
  config.pull_request_filename = "BRANCH_PULL_REQUEST"
  config.pull_request_body = "- [ ] Test pull request"
end
```

## Usage

TODO: Write usage instructions here

## Contributing

1. Create `.env` from the Secure Note `startling .env` in
   LastPass.
