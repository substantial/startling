require 'spec_helper'
require 'fileutils'
require 'startling'
require 'startling/git_local'
require 'startling/github'

describe "bin/start" do
  let(:feature_name) { 'bin-start-starts-stories' }
  let(:repo_default_branch) { 'master' }
  let(:pull_request_body) { "This is a test body" }
  let(:git) { Startling::GitLocal.new }
  let(:repo) { Startling::Github.repo(git.repo_name) }
  let(:pull_request) { repo.pull_request(feature_name) }

  before do
    local_configuration = <<CONFIG
Startling.configure do |config|
  # WIP Limit
  # config.wip_limit = 4

  # Labels for WIP pull requests
  # config.wip_labels = ["WIP", "REVIEW"]

  # Repos to check against for WIP limit
  # config.repos << 'substantial/startling-dev'

  # Valid story estimations
  # config.valid_estimates = [1, 2, 4, 8, 16, 32, 64, 128]

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
  # config.validate_branch_name = -> (branch_name) { /feature\\/.*/ =~ branch_name }

  # Message for pull request commit
  # config.pull_request_commit_message = "Startling"

  # Message for pull request body
  config.pull_request_body = "#{pull_request_body}"

  # Labels for a pull request
  # config.pull_request_labels = [WIP, REVIEW, HOLD]

  # Handler used for setting the title and body of a pull request
  config.pull_request_handler = :default_pull_request_handler
end
CONFIG

    File.open('startlingfile.rb', 'w') { |file| file.write(local_configuration) }

    Startling::Commands::Base.load_configuration

    test_repo_path = "tmp/test_repo"
    FileUtils.mkdir_p "tmp"

    unless File.exists? "tmp/test_repo/.git"
      `git clone git@github.com:substantial/startling-testing.git #{test_repo_path}`
    end

    File.write File.join(test_repo_path, ".github_access_token"), Tokens.github

    FileUtils.cd test_repo_path

    Startling.root_dir = Startling.cache_dir = "."

    git.checkout_branch repo_default_branch
    git.destroy_branch feature_name
  end

  after do
    FileUtils.cd "#{__dir__}/.."
    FileUtils.rm "startlingfile.rb"
  end

  # VCR Preconditions:
  # * There should be no open pull requests:
  #   https://github.com/substantial/startling-testing

  it "starts stories from origin/master",
    vcr: { cassette_name: "bin_start_starts_stories" } do

    allow_any_instance_of(Startling::Handlers::DefaultPullRequestHandler)
      .to receive(:ask)
      .with("Please input a pull request title: ") { "The Title" }

    allow_any_instance_of(Startling::Commands::CreateBranch)
      .to receive(:ask)
      .with("Enter branch name (enter for current branch): ") { feature_name }

    command = Startling::Command.new(args: [])
    command.execute

    expect(git.remote_branches).to include feature_name
    expect(git.current_branch).to eq feature_name
    expect(repo.default_branch).to eq repo_default_branch
  end

  it "The pull request body is the same as the config",
    vcr: { cassette_name: "bin_start_starts_stories_pr_body" } do

    allow_any_instance_of(Startling::Handlers::DefaultPullRequestHandler)
      .to receive(:ask)
      .with("Please input a pull request title: ") { "The Title" }

    allow_any_instance_of(Startling::Commands::CreateBranch)
      .to receive(:ask)
      .with("Enter branch name (enter for current branch): ") { feature_name }

    command = Startling::Command.new(args: [])
    command.execute

    expect(pull_request.attributes.body).to eq pull_request_body
  end
end
