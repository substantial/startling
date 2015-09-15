require 'startling/git_local'

module Startling
  class Configuration
    VALID_ESTIMATES = [1, 2, 4, 8, 16, 32, 64, 128]
    WIP_LIMIT = 4

    DEFAULT_STARTLINGFILES = [
      'startlingfile.rb',
      'Startlingfile.rb'
    ].freeze

    attr_accessor :cache_dir, :root_dir, :valid_estimates, :wip_limit, :repos, :pull_request_filename, :pull_request_body

    def initialize
      @cache_dir = Dir.pwd
      @root_dir = Dir.pwd
      @valid_estimates = VALID_ESTIMATES
      @wip_limit = WIP_LIMIT
      @repos = []
      @pull_request_filename = "BRANCH_PULL_REQUEST"
      @pull_request_body = ""
    end

    def self.load_configuration
      DEFAULT_STARTLINGFILES.each do |file_name|
        if Dir.entries(Startling::GitLocal.new.project_root).include? file_name
          load "#{Startling::GitLocal.new.project_root}/#{file_name}"
          return file_name
        end
      end
      nil
    end
  end
end
