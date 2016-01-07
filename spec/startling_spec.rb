require 'spec_helper'
require 'fileutils'
require 'startling'
require 'startling/git_local'
require 'startling/github'

describe "bin/start" do
  let(:feature_name) { 'bin_start_starts_stories' }
  let(:feature_branch) { "feature/#{feature_name}" }
  let(:repo_default_branch) { 'master' }
  let(:git) { Startling::GitLocal.new }
  let(:repo) { Startling::Github.repo(git.repo_name) }

  before do
    test_repo_path = "tmp/test_repo"
    FileUtils.mkdir_p "tmp"

    unless File.exists? "tmp/test_repo/.git"
      `git clone git@github.com:substantial/startling-testing.git #{test_repo_path}`
    end

    File.write File.join(test_repo_path, ".github_access_token"), Tokens.github

    FileUtils.cd test_repo_path

    Startling.root_dir = Startling.cache_dir = "."

    git.checkout_branch repo_default_branch
    git.destroy_branch feature_branch
  end

  after do
    FileUtils.cd "#{__dir__}/.."
  end

  # VCR Preconditions:
  # * There should be no open pull requests:
  #   https://github.com/substantial/startling-testing

  it "starts stories from origin/master",
    vcr: { cassette_name: "bin_start_starts_stories" } do

    allow_any_instance_of(Startling::Handlers::DefaultPullRequestHandler)
      .to receive(:ask)
      .with("Please input a pull request title: ") { "The Title" }

    allow_any_instance_of(Startling::Handlers::DefaultPullRequestHandler)
      .to receive(:ask)
      .with("Please input a pull request body: (default is empty)") { "The Body" }

    allow_any_instance_of(Startling::Commands::CreateBranch)
      .to receive(:ask)
      .with("Enter branch name (enter for current branch): ") { feature_name }

    command = Startling::Command.new(args: [])
    command.execute

    git = Startling::GitLocal.new

    expect(git.remote_branches).to include feature_branch
    expect(git.current_branch).to eq feature_branch
    expect(repo.default_branch).to eq repo_default_branch
  end
end
