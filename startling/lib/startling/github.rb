require 'octokit'

require_relative 'github/repo'
require_relative 'github/api'

module Startling
  module Github
    def self.api
      @api ||= Github::Api.new
    end

    def self.repo(name)
      api.repository(name)
    end
  end
end
