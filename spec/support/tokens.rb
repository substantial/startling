module Tokens
  def self.github
    ENV.fetch("TEST_GITHUB_ACCESS_TOKEN") { raise "Copy startling .env from LastPass into .env" }
  end
end
