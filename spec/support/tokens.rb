module Tokens
  def self.github
    ENV.fetch("TEST_GITHUB_ACCESS_TOKEN") { raise "Copy .env from LastPass please" }
  end

  def self.pivotal_tracker
    ENV.fetch("TEST_PIVOTAL_TRACKER_API_TOKEN") { raise "Copy .env from LastPass please" }
  end
end
