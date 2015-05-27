require 'spec_helper'
require 'fileutils'
require 'startling'
require 'startling/git_local'

describe "bin/start" do
  let(:feature_name) { 'bin_start_starts_stories' }
  let(:feature_branch) { "feature/#{feature_name}" }
  let(:repo_default_branch) { 'develop' }
  let(:git) { Startling::GitLocal.new }
  let(:pivotal_story_id) { "65074482" }

  before do
    test_repo_path = "tmp/test_repo"
    FileUtils.mkdir_p "tmp"
    unless File.exists? "tmp/test_repo/.git"
      `git clone git@github.com:TeachingChannel/teaching-channel-start-testing.git #{test_repo_path}`
    end

    File.write File.join(test_repo_path, ".github_access_token"), Tokens.github
    File.write File.join(test_repo_path, ".pivotal_api_token"), Tokens.pivotal_tracker

    stub_const("Startling::REPOS", ["TeachingChannel/teaching-channel-start-testing"])
    FileUtils.cd test_repo_path

    Startling.root_dir = Startling.cache_dir = "."

    git.checkout_branch 'develop'
    git.destroy_branch feature_branch
  end

  after do
    FileUtils.cd "#{__dir__}/.."
  end

  # VCR Preconditions:
  # * There should be no open pull requests:
  #   https://github.com/TeachingChannel/startling-testing
  # * The story should be estimated and unstarted:
  #   https://www.pivotaltracker.com/story/show/65074482
  #   Credentials for this project:
  #     email: aaron+tchtesting@substantial.com
  #     password: asdfasdf
  #

  it "starts stories from origin/develop",
    vcr: { cassette_name: "bin_start_starts_stories" } do
    allow_any_instance_of(Startling::Commands::ThreeAmigos)
      .to receive(:ask) { "ole" }

    command = Startling::Command.new(args: [pivotal_story_id, feature_name])
    command.execute

    expect(git.remote_branches).to include feature_branch
    expect(git.current_branch).to eq feature_branch
    expect(command.default_branch).to eq(repo_default_branch)
  end
end
