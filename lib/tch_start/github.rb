require 'octokit'

require_relative 'github/repo'
require_relative 'github/api'

module TchStart
  module Github
    def self.api
      @api ||= Github::Api.new
    end

    def self.repo(name)
      Repo.new(name, api)
    end
  end
end
