# Startling

## Installation

Add this line to your application's Gemfile:

    gem 'startling'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install startling

Generate configuration file in rails. 
Use -H to generate a handler folder and -C to generate a commands folder

    $ rails g startling:configuration 

## Configuration

Startlingfile.rb or startlingfile.rb should be defined in the root of the project. It can contain a block for configuration:

```ruby
Startling.configure do |config|
  # WIP Limit
  # config.wip_limit = 4

  # Labels for WIP pull requests
  # config.wip_labels = ["WIP", "REVIEW"]

  # Repos to check against for WIP limit
  # config.repos << "substantial/startling"

  # Commands to be run before a story is stared
  # config.hook_commands.before_story_start = [:check_wip]

  # Command to be run after a story has started
  # config.hook_commands.after_story_start = []

  # Commands to be run before a pull request is created
  # config.hook_commands.before_pull_request = []

  # Commands to be run after a pull request is created
  # config.hook_commands.after_pull_request = []

  # Handler used to start a provider specific story related to the pull request
  # config.story_handler = :pivotal_start

  # Validate branch name with a Proc that returns a boolean
  # config.validate_branch_name = -> (branch_name) { /feature\/.*/ =~ branch_name }

  # Message for pull request commit
  # config.pull_request_commit_message = "Startling"

  # Message for pull request body
  # config.pull_request_body = "Startling Body"

  # Labels for a pull request
  # config.pull_request_labels = [WIP, REVIEW, HOLD]

  # Handler used for setting the title and body of a pull request
  #config.pull_request_handler = :custom_pull_request_handler
end
```

## Usage

Start a new story with a given story id

    $ start 12345

Start a new story with a given story id and branch name

    $ start 12345 foo

## Development

After checking out the repo, run `cd startling/startling && bin/setup` to
install dependencies. Create `.env` from the Secure Note `startling .env` in
LastPass. Then, run `rake spec` to run the tests. You can also run
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
