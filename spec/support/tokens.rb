module Tokens
  def self.github
    ENV.fetch("TEST_GITHUB_ACCESS_TOKEN") { raise "Copy startling .env from LastPass into .env" }
  end

  def self.pivotal_tracker
    ENV.fetch("TEST_PIVOTAL_TRACKER_API_TOKEN") { raise "Copy startling .env from LastPass into .env" }
  end
end
