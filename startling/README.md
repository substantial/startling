# Startling

Utility script for starting a story from a Github repository.

1. Checks WIP limit. (optional)
1. Starts the story in your project management tool (optional).
   [Pivotal Tracker](https://rubygems.org/gems/startling_pivotal) and
   [Trello](https://rubygems.org/gems/startling_trello) are
   supported.
1. Creates a branch if the specified branch does not already exist.
1. Opens a pull request on Github.

## Installation

Add this line to your application's Gemfile:

    gem 'startling'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install startling

Generate configuration file in rails. 
Use -H to generate a handlers directory and -C to generate a commands directory

    $ rails g startling:configuration 

## Configuration

Startlingfile.rb or startlingfile.rb should be defined in the root of the
project. It can contain a block for configuration:

```ruby
Startling.configure do |config|
  # Commands to be run before a story is stared
  # config.hook_commands.before_story_start = [:check_wip]

  # Commands to be run after a story has started
  # config.hook_commands.after_story_start = []

  # Commands to be run before a pull request is created
  # config.hook_commands.before_pull_request = []

  # Commands to be run after a pull request is created
  # config.hook_commands.after_pull_request = []

  # Handler used to start a provider specific story related to the pull request
  # config.story_handler = :pivotal_start

  # Handler used for setting the title and body of a pull request
  # config.pull_request_handler = :default_pull_request_handler
end
```

### 1. WIP limit

WIP is calculated by the number of pull requests open in the repository. 

Set WIP limit:

```ruby
config.wip_limit = 4
```

### 2. WIP labels

You can limit the pull requests included in WIP by configuring the pull request
labels for WIP.

```ruby
config.wip_labels = ["WIP", "REVIEW"]
```

### 3. WIP repositories

WIP limit can be checked across multiple Github repositories. Use the same
branch name across repositories to count multiple pull requests as only one WIP.

```ruby
config.repos << "substantial/startling"
```

### 4. Check the WIP limit before starting a story:

```ruby
config.hook_commands.before_story_start = [:check_wip]
```

### 5. Branch name

You can check the branch name being used with a custom Proc. For example, this
Proc only allows branches that are prefixed with `feature/`:

```ruby
config.validate_branch_name = -> (branch_name) { /feature\/.*/ =~ branch_name }
```

### 6. Pull request commit message

If the branch is newly created, Startling must create an empty commit in order
to open a pull request. The commit message for the empty commit can be set:

```ruby
config.pull_request_commit_message = "Startling"
```

### 7. Pull request description

You will be prompted to set a title for the pull request, but the pull request
description is set to a default value that can be configured:

```ruby
config.pull_request_body = "Startling Body"
```

### 8. Pull request labels

You can set one or more labels on the pull request:

```ruby
config.pull_request_labels = [WIP, REVIEW, HOLD]

config.hook_commands.after_pull_request = [:label_pull_request]
```

## Usage

Start a new story with a given story id

    $ start '#12345'

Start a new story with a given story id and branch name

    $ start '#12345' foo

Check WIP

    $ wip

## Commands

Commands are custom Ruby scripts that can be run at various stages of Startling.

1. Before the story is started
1. After the story is started
1. Before the pull request is opened
1. After the pull request is opened

### Creating a custom command

Custom commands should be put in the startling/commands directory. Create a
Ruby class that inherits from the Startling::Commands::Base class and
implements an execute method. Add your command class to the corresponding
config value for the stage in which your command should be executed.

```ruby
config.hook_commands.before_story_start = [:check_wip]
```

## Handlers

Handlers allow for customization of Startling behavior.

Existing handlers:

1. PullRequestHandler

Handles setting the title and description of the pull request and setting the
commit message for the empty commit.

### Creating a custom handler

Custom handlers should be put in the startling/handlers directory.

1. PullRequestHandler

Create a Ruby class that inherits from the PullRequestHandler::Base class. Set
`pull_request_handler` config value to your handler class.

```ruby
config.pull_request_handler = :default_pull_request_handler
```

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
