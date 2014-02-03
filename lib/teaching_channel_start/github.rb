require 'octokit'

require_relative 'github/repo'
require_relative 'github/api'

module TeachingChannelStart
  module Github
    def self.api
      @api ||= Github::Api.new
    end

    def self.repo(name)
      api.repository(name)
    end
  end
end
