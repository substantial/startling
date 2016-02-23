require 'cgi'
require 'json'
require 'highline/import'
require 'shellwords'
require_relative "story"
require_relative "commands/base"
require_relative 'commands/check_for_local_mods'
require_relative 'commands/create_pull_request'

module Startling
  class Command < Commands::Base
    RUN = "run"

    def self.run(attrs={})
      options = Startling::CliOptions.parse
      options.merge!(attrs)
      options.merge({argv: ARGV, args: ARGV})

      super(options)
    end

    def execute
      load_configuration
      load_commands
      load_handlers

      command_args = cli_options.merge(git: git)

      check_for_local_mods

      run_hook_commands(hook: :before_story_start, command_args: command_args)
      start_story(command_args)
      run_hook_commands(hook: :after_story_start, command_args: command_args)

      run_hook_commands(hook: :before_pull_request, command_args: command_args)
      create_pull_request(command_args)
      run_hook_commands(hook: :after_pull_request, command_args: command_args)
    end

    def git
      @git ||= GitLocal.new
    end

    private

    def check_for_local_mods
      Commands::CheckForLocalMods.run(git: git)
    end

    def run_hook_commands(hook:, command_args:)
      Startling.hook_commands.send(hook).map do |command|
        command_class(command).send(RUN, command_args)
      end
    end

    def start_story(command_args)
      story = command_class(Startling.story_handler)
        .send(RUN, command_args) if Startling.story_handler
      command_args.merge!(story: story)
    end

    def create_pull_request(command_args)
      pull_request = command_class(:create_pull_request)
        .send(RUN, command_args)
      command_args.merge!(pull_request: pull_request)
    end
  end
end
