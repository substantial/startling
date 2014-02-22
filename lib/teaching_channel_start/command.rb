require 'cgi'
require 'json'
require 'highline/import'
require 'shellwords'
require 'colored'

require_relative 'cache'
require_relative 'pivotal_tracker'
require_relative 'work'
require_relative 'work_printer'
require_relative 'git_helpers'
require_relative 'misc_helpers'
require_relative 'commands/create_pull_request'
require_relative 'commands/create_changelog'
require_relative 'usage_help'

# script/start
#
# This script automates the process of starting a new story. Check the call
# method the script for the step-by-step. It uses the Github and
# Pivotal Tracker APIs.

module TeachingChannelStart
  class Command
    include GitHelpers
    include MiscHelpers

    attr_reader :args, :pivotal_tracker
    def initialize(args = ARGV)
      @args = args
      @pivotal_tracker = PivotalTracker.new(pivotal_api_token)
    end

    def call
      check_for_local_mods
      print_help
      set_pivotal_api_token
      check_wip
      start_story
      create_branch if branch_name != current_branch
      Commands::CreateChangelog.new(story: story).call
      Commands::CreatePullRequest.new(repo: repo, story: story, branch_name: branch_name).call
    end

    def cache
      TeachingChannelStart.cache
    end

    def print_help
      if args[0] == '--help' || args[0] == '-h'
        UsageHelp.print
        exit 0
      end
    end

    def check_wip
      puts "Checking WIP..."
      wip = Work.in_progress
      if wip.count >= WIP_LIMIT
        WorkPrinter.new.print wip
        puts
        question = [
          "Would you like to continue to add to that (",
          "anything but \"yes\" will abort".underline,
          ")? "
        ].map(&:yellow).join
        confirm = ask(question)

        exit unless confirm == "yes"
      end
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
      create_remote_branch(branch_name, base_branch: "origin/#{default_branch}")
    end

    def default_branch
      repo.default_branch
    end

    def repo
      @repo ||= Github.repo(repo_name)
    end

    def story
      @story ||= pivotal_tracker.story(story_id)
    end

    def start_story
      puts "Starting story..."
      estimate = ask_for_estimate unless story.estimated?
      story.start(starter_id: pivotal_tracker.user_id, estimate: estimate)
    end

    def ask_for_estimate
      puts "'#{story.name}' is not estimated."
      begin
        estimate = ask("Enter estimate (#{VALID_ESTIMATES.join(", ")}): ")
        estimate = Integer(estimate)
        raise 'Invalid estimate' unless VALID_ESTIMATES.include? estimate
        return  estimate.to_i
      rescue => e
        puts e.message
        retry
      end
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
        if current_branch_is_a_feature_branch?
          return current_branch
        else
          abort "Branch name must be specified when current branch is not feature/."
        end
      end

      branch.gsub!(/feature\//, '')
      "feature/#{branch}".gsub(/\s+/, '-')
    end
  end
end
