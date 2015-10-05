require 'cgi'
require 'json'
require 'highline/import'
require 'shellwords'

require_relative 'pivotal_tracker'

require_relative "commands/base"
require_relative 'commands/print_usage'
require_relative 'commands/check_for_local_mods'

# script/start
#
# This script automates the process of startling a new story. Check the call
# method the script for the step-by-step. It uses the Github and
# Pivotal Tracker APIs.

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

      Startling.hook_commands.before_story_start.map do |command|
        command_class(command).send(RUN, command_args)
      end

      Startling.hook_commands.story_start.map do |command|
        command_class(command).send(RUN, command_args)
      end

      create_branch if branch_name != git.current_branch

      Startling.hook_commands.after_story_start.map do |command|
        command_class(command).send(RUN, command_args)
      end

      Startling.hook_commands.before_pull_request.map do |command|
        command_class(command).send(RUN, command_args)
      end

      Startling.hook_commands.create_pull_request.map do |command|
        @pull_request = command_class(command).send(RUN, command_args.merge({branch_name: branch_name}))
      end

      Startling.hook_commands.after_pull_request.map do |command|
        command_class(command).send(RUN, command_args.merge({pull_request: @pull_request}))
      end
    end

    def command_class(command)
      Startling::Commands.const_get(command.to_s.camelize)
    end

    def create_branch
      puts "Creating branch #{branch_name}..."
      git.create_remote_branch(branch_name, base_branch: "origin/#{default_branch}")
    end

    def default_branch
      repo.default_branch
    end

    def git
      @git ||= GitLocal.new
    end

    def repo
      @repo ||= Github.repo(git.repo_name)
    end

    def branch_name
      @branch_name ||= get_branch_name
    end

    def get_branch_name
      branch = if args.length > 1
                 args[1..-1].map(&:downcase).join('-')
               else
                 ask("Enter branch name (enter for current branch): ")
               end

      if branch.empty?
        if git.current_branch_is_a_feature_branch?
          return git.current_branch
        else
          abort "Branch name must be specified when current branch is not feature/."
        end
      end

      branch.gsub!(/feature\//, '')
      "feature/#{branch}".gsub(/\s+/, '-')
    end
  end
end
