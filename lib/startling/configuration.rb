require 'startling/git_local'

module Startling
  class Configuration
    DEFAULT_COMMAND_PATH = "startling/commands"
    DEFAULT_PULL_REQUEST_FILENAME = "BRANCH_PULL_REQUEST"
    DEFAULT_VALID_ESTIMATES = [1, 2, 4, 8, 16, 32, 64, 128]
    DEFAULT_WIP_LIMIT = 4

    DEFAULT_STARTLINGFILES = [
      'startlingfile.rb',
      'Startlingfile.rb'
    ].freeze

    attr_accessor :cache_dir, :root_dir, :valid_estimates, :wip_limit, :repos,
      :pull_request_labels, :pull_request_filename, :pull_request_body

    def initialize
      @cache_dir = Dir.pwd
      @root_dir = Dir.pwd
      @repos = []
      @valid_estimates = DEFAULT_VALID_ESTIMATES
      @wip_limit = DEFAULT_WIP_LIMIT
      @pull_request_labels = []
      @pull_request_filename = DEFAULT_PULL_REQUEST_FILENAME
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

    def self.load_hooks(path=DEFAULT_COMMAND_PATH)
      command_dir = File.join(Startling::GitLocal.new.project_root, path, "*")
      return unless command_dir
      Dir.glob(command_dir).each do |command|
        load "#{command_dir}/#{command}"
      end
      command_dir
    end

    def hooks
      @hooks ||= Hooks.new
    end

    class Hooks
      attr_accessor :before_story_start, :story_start, :after_story_start,
      :before_pull_request, :after_pull_request

      def initialize
        @before_story_start = []
        @story_start = [::Startling::Commands::StartStory]
        @after_story_start = []
        @before_pull_request = []
        @after_pull_request = []
      end
    end
  end
end
