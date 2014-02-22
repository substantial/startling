require 'cgi'
require 'json'
require 'highline/import'
require 'shellwords'
require 'colored'

require_relative 'cache'
require_relative 'pivotal_tracker'
require_relative 'commands/create_pull_request'
require_relative 'commands/create_changelog'
require_relative 'commands/print_usage'
require_relative 'commands/check_wip'
require_relative 'commands/start_story'
require_relative "commands/base"

# script/start
#
# This script automates the process of starting a new story. Check the call
# method the script for the step-by-step. It uses the Github and
# Pivotal Tracker APIs.

module TeachingChannelStart
  class Command < Commands::Base
    def initialize(args = ARGV)
      super(args: args, pivotal_tracker: PivotalTracker.new(pivotal_api_token))
    end

    def execute
      check_for_local_mods
      Commands::PrintUsage.run(args: args)
      set_pivotal_api_token
      Commands::CheckWip.run
      Commands::StartStory.run(story: story, pivotal_tracker: pivotal_tracker)
      create_branch if branch_name != GitLocal.current_branch
      Commands::CreateChangelog.run(story: story)
      Commands::CreatePullRequest.run(repo: repo, story: story, branch_name: branch_name)
    end

    def cache
      TeachingChannelStart.cache
    end

    def pivotal_api_token
      @pivotal_api_token ||= cache.fetch('.pivotal_api_token') do
        username = ask("Enter your Pivotal Tracker username:  ")
        password = ask("Enter your Pivotal Tracker password:  ") { |q| q.echo = false }
        PivotalTracker::Api.api_token_for_user(username, password)
      end
    end
    alias_method :set_pivotal_api_token, :pivotal_api_token

    def check_for_local_mods
      return if `git status --porcelain`.empty?

      puts "Local modifications detected, please stash or something."
      system("git status -s")
      exit 1
    end

    def create_branch
      puts "Creating branch #{branch_name}..."
      GitLocal.create_remote_branch(branch_name, base_branch: "origin/#{default_branch}")
    end

    def default_branch
      repo.default_branch
    end

    def repo
      @repo ||= Github.repo(GitLocal.repo_name)
    end

    def story
      @story ||= pivotal_tracker.story(story_id)
    end

    def story_id
      @story_id ||= args.fetch(0) { ask("Enter story id to start: ") }
    end

    def branch_name
      return @branch_name if defined? @branch_name
      @branch_name = get_branch_name
    end

    def get_branch_name
      branch = if args.length > 1
                 args[1..-1].map(&:downcase).join('-')
               else
                 ask("Enter branch name (enter for current branch): ")
               end

      if branch.empty?
        if GitLocal.current_branch_is_a_feature_branch?
          return GitLocal.current_branch
        else
          abort "Branch name must be specified when current branch is not feature/."
        end
      end

      branch.gsub!(/feature\//, '')
      "feature/#{branch}".gsub(/\s+/, '-')
    end
  end
end
