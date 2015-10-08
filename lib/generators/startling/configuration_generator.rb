require 'rails/generators'
require 'rails/generators/base'

module Startling
  module Generators
    class ConfigurationGenerator < Rails::Generators::Base
      def create_startling_folders
        pull_request_handler_file = "#{destination_root.split('/').last.underscore}_pull_request_handler"
        create_file "startlingfile.rb" do
<<CONFIG
Startling.configure do |config|
  #config.wip_limit = 10
  #config.repos << 'substantial/startling-dev-test'

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

  # Handler used for setting the title and body of a pull request
  #config.pull_request_handler = :#{pull_request_handler_file}
end
CONFIG
        end

        empty_directory "startling"
        empty_directory "startling/commands"
        empty_directory "startling/handlers"
        create_file "startling/handlers/#{pull_request_handler_file}.rb" do
<<HANDLER_CLASS
class #{pull_request_handler_file.camelize} < Startling::Handlers::PullRequestHandlerBase
end
HANDLER_CLASS
        end
      end
    end
  end
end
