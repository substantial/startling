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
  # WIP Limit - Defaults to 4
  # config.wip_limit = 8

  # Repos to check against for WIP limit
  # config.repos << 'substantial/startling-dev'

  # Valid story estimations - Defaults to [1, 2, 4, 8, 16, 32, 64, 128]
  # config.valid_estimates = [1, 2, 3, 4]

  # Commands to be run before a story is stared
  # config.hook_commands.before_story_start = [:check_wip]

  # Command to be run after a story has started
  # config.hook_commands.after_story_start = []

  # Commands to be run before a pull request is created
  # config.hook_commands.before_pull_request = []

  # Commands to be run after a pull request is created
  # config.hook_commands.after_pull_request = []

  # Handler used to start a provider specific story related to the pull request
  config.story_handler = :start_pivotal_story

  # Message for pull request commit - Defaults to "Startling"
  # config.pull_request_commit_message = "Commit message"

  # Labels for a pull request
  # config.pull_request_labels = [WIP, REVIEW, HOLD]

  # Handler used for setting the title and body of a pull request
  #config.pull_request_handler = :custom_pull_request_handler
end
```

## Usage

TODO: Write usage instructions here

## Contributing

1. Create `.env` from the Secure Note `startling .env` in
   LastPass.
