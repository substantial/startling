require 'spec_helper'
require 'fileutils'

describe "bin/start" do
  after do
    FileUtils.cd "#{__dir__}/.."
  end

  # VCR Preconditions:
  # * There should be no open pull requests:
  #   https://github.com/TeachingChannel/teaching-channel-start-testing
  # * The story should be estimated and unstarted:
  #   https://www.pivotaltracker.com/story/show/65074482
  it "starts stories",
    vcr: { cassette_name: "bin_start_starts_stories" } do
    test_repo_path = "tmp/test_repo"
    FileUtils.mkdir_p "tmp"
    unless File.exists? "tmp/test_repo/.git"
      `git clone git@github.com:TeachingChannel/teaching-channel-start-testing.git #{test_repo_path}`
    end

    File.write File.join(test_repo_path, ".github_access_token"), Tokens.github
    File.write File.join(test_repo_path, ".pivotal_api_token"), Tokens.pivotal_tracker

    stub_const("TeachingChannelStart::REPOS", ["TeachingChannel/teaching-channel-start-testing"])
    FileUtils.cd test_repo_path
    TeachingChannelStart.root_dir = TeachingChannelStart.cache_dir = "."
    TeachingChannelStart::Command.new(["65074482", "bin_start_starts_stories"]).call
  end
end
