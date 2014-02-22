require 'spec_helper'
require 'fileutils'

describe "bin/start" do
  include GitHelpers

  let(:feature_name) { 'bin_start_starts_stories' }
  let(:feature_branch) { "feature/#{feature_name}" }

  before do
    test_repo_path = "tmp/test_repo"
    FileUtils.mkdir_p "tmp"
    unless File.exists? "tmp/test_repo/.git"
      `git clone git@github.com:TeachingChannel/teaching-channel-start-testing.git #{test_repo_path}`
    end

    File.write File.join(test_repo_path, ".github_access_token"), Tokens.github
    File.write File.join(test_repo_path, ".pivotal_api_token"), Tokens.pivotal_tracker

    stub_const("TeachingChannelStart::REPOS", ["TeachingChannel/teaching-channel-start-testing"])
    FileUtils.cd test_repo_path

    checkout_branch 'master'
    destroy_branch feature_branch

    TeachingChannelStart.root_dir = TeachingChannelStart.cache_dir = "."
  end

  after do
    FileUtils.cd "#{__dir__}/.."
  end

  # VCR Preconditions:
  # * There should be no open pull requests:
  #   https://github.com/TeachingChannel/teaching-channel-start-testing
  # * The story should be estimated and unstarted:
  #   https://www.pivotaltracker.com/story/show/65074482
  #
  subject { TeachingChannelStart::Command.new(["65074482", feature_name]).call }

  context 'with origin/develop ' do
    it "starts stories from origin/develop",
      vcr: { cassette_name: "bin_start_starts_stories" } do
      create_remote_branch 'develop'

      subject
      remote_branches.should include feature_branch
      current_branch.should eq feature_branch
    end
  end

  context 'without origin/develop' do
    it "starts stories from origin/master",
      vcr: { cassette_name: "bin_start_starts_stories" } do
      destroy_branch 'develop'

      subject
      remote_branches.should include feature_branch
      current_branch.should eq feature_branch
    end
  end
end
