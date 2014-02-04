require 'cgi'
require 'json'
require 'highline/import'
require 'shellwords'
require 'colored'

require_relative 'cache'
require_relative 'pivotal_tracker'
require_relative 'work'
require_relative 'work_printer'

# script/start
#
# This script automates the process of starting a new story. Check the call
# method the script for the step-by-step. It currently depends on hub being
# installed and uses the Pivotal Tracker API.

module TeachingChannelStart
  class Command
    attr_reader :args, :pivotal_tracker
    def initialize(args = ARGV)
      @args = args
      @pivotal_tracker = PivotalTracker.new(pivotal_api_token)
    end

    def call
      check_for_local_mods
      check_for_hub
      print_help
      set_pivotal_api_token
      check_wip
      start_story
      create_branch if branch_name
      update_changelog
      url = open_pull_request
      amend_commit_with_pull_request(url)
    end

    def cache
      TeachingChannelStart.cache
    end

    def check_for_hub
      unless system "which hub > /dev/null 2>&1"
        puts "Please install hub with:

      $ brew install hub"
        exit 1
      end
    end

    def print_help
      if args[0] == '--help' || args[0] == '-h'
        puts "Usage:

      $ script/start <story id> <branch name>

      <story id>: Pivotal story id
      <branch name>: Branch name without feature/. Can be separated by spaces or dashes.

      Example:

      $ script/start 12345 my favorite feature"
        exit 0
      end
    end

    def check_wip
      puts "Checking WIP..."
      wip = Work.in_progress
      if wip.count >= WIP_LIMIT
        WorkPrinter.new.print wip

        confirm = ask("Would you like to continue to add to that? (anything but yes will exit)")
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

    def run(command)
      result = `#{command}`
      unless $?.success?
        exit 1
      end
      result
    end

    def changelog_message
      "* **#{story.story_type.upcase}:** [#{escape_markdown(story.name)}](#{story.url})"
    end

    def escape_markdown(text)
      text.gsub('[', '\[').gsub(']', '\]')
    end

    def changelog_filename
      'BRANCH_CHANGES.md'
    end

    def changelog_path
      File.join(TeachingChannelStart.root_dir, changelog_filename)
    end

    def pull_request_filename
      'BRANCH_PULL_REQUEST'
    end

    def pull_request_path
      File.join(TeachingChannelStart.root_dir, pull_request_filename)
    end

    def read_changelog
      if File.exists? changelog_path
        changelog_contents = File.read(changelog_path)
      end
    end

    def update_changelog
      changelog_contents = read_changelog || ''
      return if changelog_contents.include? story.name

      puts "Updating #{changelog_filename}..."

      entries = changelog_contents.lines.to_a
      entries << changelog_message
      new_contents = entries.uniq.sort {|a,b| a <=> b}.join("\n")

      File.write(changelog_path, "#{new_contents}\n")

      run "git add #{changelog_filename}"
      commit_msg = <<-MSG
Update BRANCH_CHANGES

#{story.name}
#{story.url}
MSG
      run "git commit -qm #{commit_msg.shellescape}"
    end

    def pull_request_editor
      # hub doens't have a way to set the body of the pull request from the command
      # line, just the title. This uses vim to do it automatically.

      browsers = [
        "IE8 (minor issues are acceptable)",
        "IE9",
        "IE10",
        "IE11",
        "Firefox",
        "Safari",
        "Chrome",
      ]
      browser_checkboxes = browsers.map { |browser| "- [ ] Test in #{browser}" }.join("\\<cr>")
      commands = [
        "normal ggcGWIP: #{story.name}",
        "exe \"normal o\\<cr>#{story.url}\\<cr>\\<cr>#{browser_checkboxes}\"",
        "wq"
      ].map { |command| "+#{command.shellescape}" }
      vim = "#{`command which vim`.chomp} #{commands.join(" ")}".shellescape

      "GIT_EDITOR=#{vim}"
    end

    def check_for_local_mods
      return if `git status --porcelain`.empty?

      puts "Local modifications detected, please stash or something."
      system("git status -s")
      exit 1
    end

    def create_branch
      puts "Creating branch #{branch_name}..."
      run "git fetch -q"
      run "git checkout -q #{branch_name} 2>/dev/null || git checkout -q -b #{branch_name} origin/develop"
    end

    def open_pull_request
      puts "Opening pull request..."
      run "git push -qu origin HEAD > /dev/null"
      url = run "env #{pull_request_editor} NOEXEC_DISABLE=1 ruby #{`command which hub`.chomp} pull-request -b develop -f"
      url = url[/https:\/\/github\.com.*$/]
      puts "Opened pull request: #{url}"
      url
    end

    def amend_commit_with_pull_request(url)
      File.open(pull_request_path, "a") do |file|
        file.puts url
      end

      run "git add #{pull_request_path}"
      run "git commit -q --amend --reuse-message=HEAD"
      run "git push -qf origin HEAD"
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
          return nil
        else
          abort "Branch name must be specified when current branch is not feature/."
        end
      end

      branch.gsub!(/feature\//, '')
      "feature/#{branch}".gsub(/\s+/, '-')
    end

    def current_branch_is_a_feature_branch?
      `git symbolic-ref -q --short HEAD` =~ %r{^feature/}
    end
  end
end
