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

    $ rails g startling_pivotal:configuration 

## Configuration

### Startling Configuration

startlingfile.rb or Startlingfile.rb should be defined at the root of the
project. It can contain a block for configuration.

Add the following line to the beginning of the Startling configuration file:

```ruby
require 'startling_pivotal'
```

Add or update the following line of the Startling configuration file:

```ruby
Startling.configure do |config|
  config.story_handler = :pivotal_start
end
```

### Startling Pivotal Configuration

The following configuration values can be set:

```ruby
Startling.configure do |config|
  # Valid story estimations
  # config.valid_estimates = [1, 2, 3]
end
```

## Usage

Start a new story with a given story id:

    $ start 12345

Start a new story with a given story id and branch name:

    $ start 12345 foo

Check story status:

    $ story_status 12345

## Development

After checking out the repo, run `cd startling/startling_pivotal && bin/setup`
to install dependencies. Create `.env` from the Secure Note `startling_pivotal
.env` in LastPass. Then, run `rake spec` to run the tests. You can also run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/substantial/startling. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
