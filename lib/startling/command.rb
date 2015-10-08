require 'cgi'
require 'json'
require 'highline/import'
require 'shellwords'
require_relative 'pivotal_tracker'
require_relative "commands/base"
require_relative 'commands/print_usage'
require_relative 'commands/check_for_local_mods'
require_relative 'commands/create_pull_request'

module Startling
  class Command < Commands::Base
    RUN = "run"

    def self.run(attrs={})
      load_configuration
      load_hook_commands
      attrs[:args] ||= ARGV
      super(attrs)
    end

    def execute
      Commands::PrintUsage.run(args: args)
      Commands::CheckForLocalMods.run(git: git)
      command_args = { args: args, git: git }

      # Before Start Story
      Startling.hook_commands.before_story_start.map do |command|
        command_class(command).send(RUN, command_args)
      end

      # Start story
      story_result = command_class(Startling.story_handler)
        .send(RUN, command_args) if Startling.story_handler
      command_args.merge!({story_result: story_result}) if story_result

      # After Story Start
      Startling.hook_commands.after_story_start.map do |command|
        command_class(command)
          .send(RUN, command_args)
      end

      #Before Pull Request Creation
      Startling.hook_commands.before_pull_request.map do |command|
        command_class(command)
          .send(RUN, command_args)
      end

      # Create pull request
      pull_request = command_class(:create_pull_request)
        .send(RUN, command_args.merge({pull_request_handler: Startling.pull_request_handler}))

      # After Pull Request Creation
      Startling.hook_commands.after_pull_request.map do |command|
        command_class(command)
          .send(RUN, command_args.merge({pull_request: pull_request}))
      end
    end

    def command_class(command)
      Startling::Commands.const_get(command.to_s.camelize)
    end

    def git
      @git ||= GitLocal.new
    end
  end
end
