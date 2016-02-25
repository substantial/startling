# StartlingTrello

Hooks into [Startling](https://rubygems.org/gems/startling) to start a Trello
story. Moves the Trello card for the story to the Doing list. Uses the card
name for the pull request title and the card URL for the pull request
description.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'startling_trello'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install startling_trello

Generate configuration file in Rails:

    $ rails g startling:configuration
    $ rails g startling_trello:configuration

## Configuration

### Startling Trello Configuration

startling_trello_file.rb should be defined at the root of the project. It can
contain a block for configuration:

```ruby
StartlingTrello.configure do |config|
  # Trello Developer API key
  # config.developer_public_key = 'developer-public-key'

  # Trello Doing List ID
  # config.doing_list_id = 'doing-list-id'
end
```

#### Trello Developer API key

The Trello Developer API key is required for integration with Trello API. When
running any of the scripts, a browser window will be launched to get a key if
the key is not specified in the configuration. Copy the key into the
configuration file.

#### Trello Member Token

Anyone using Startling Trello will have to authorize the Trello Developer API
key. When running any of the scripts, a browser window will be launched to
authorize the key. After authorizing the Trello key, a token will be displayed.
Copy the token and enter it into the prompt. The token will be cached in the
`.trello_member_token` file in the root of your project.

#### Trello Doing List ID

Startling Trello needs to know the ID of the Doing list in order to move cards
to that list. To get the list ID, run `boards` to get the list of your Trello
boards. Copy the board ID, and run `lists <board-id>`. Copy the list ID into
the configuration file.

### Startling Configuration

Add the following line to the beginning of the Startling configuration file:

```ruby
require 'startling_trello'
```

Add or update the following line of the Startling configuration file:

```ruby
config.story_handler = :trello_start
```

## Usage

Start a new story with a given card ID:

    $ start 12345

Start a new story with a given card ID and branch name:

    $ start 12345 foo

Get list of your Trello boards:

    $ boards

Get list of the lists in the Trello board:

    $ lists <board-id>

## Development

After checking out the repo, run `cd startling_trello && bin/setup` to install
dependencies. Then, run `rake spec` to run the tests. You can also run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/[USERNAME]/startling_trello. This project is intended to be
a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

