# Startling Pivotal Tracker

Hooks into [Startling](https://rubygems.org/gems/startling) to start a Pivotal
Tracker story. Uses the story name for the pull request title and the story URL
for the pull request description.

## Installation

Add this line to your application's Gemfile:

    gem 'startling_pivotal'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install startling_pivotal

Generate configuration file in Rails: 

    $ rails g startling:configuration 
    $ rails g startling_pivotal:configuration 

## Configuration

### Startling Pivotal Configuration

startling_pivotal_file.rb should be defined at the root of the project. It can
contain a block for configuration:

```ruby
StartlingPivotal.configure do |config|
  # Valid story estimations
  # config.valid_estimates = [1, 2, 3]
end
```

### Startling Configuration

Add the following line to the beginning of the Startling configuration file:

```ruby
require 'startling_pivotal'
```

Add or update the following line of the Startling configuration file:

```ruby
config.story_handler = :pivotal_start
```

## Usage

Start a new story with a given story id:

    $ start 12345

Start a new story with a given story id and branch name:

    $ start 12345 foo

Check story status:

    $ story_status 12345

## Development

1. Create `.env` from the Secure Note `startling .env` in
   LastPass.
1. `gem install bundler`
1. `bundle install`

### Running tests

`rake`

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/substantial/startling. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
