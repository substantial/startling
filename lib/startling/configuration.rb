require 'startling/git_local'
require 'startling/github'
require 'startling/commands/label_pull_request'
require 'startling/commands/start_pivotal_story'
require 'startling/colorize_string'
require 'startling/handlers/default_pull_request_handler'

module Startling
  class Configuration
    DEFAULT_COMMAND_PATH = "startling/commands"
    DEFAULT_HANDLER_PATH = "startling/handlers"
    DEFAULT_VALID_ESTIMATES = [1, 2, 4, 8, 16, 32, 64, 128]
    DEFAULT_WIP_LIMIT = 4
    DEFAULT_COMMIT_MESSAGE = "Startling"

    DEFAULT_STARTLINGFILES = [
      'startlingfile.rb',
      'Startlingfile.rb'
    ].freeze

    attr_accessor :cache_dir, :root_dir, :valid_estimates, :wip_limit, :repos, :story_handler,
      :pull_request_handler, :pull_request_labels, :pull_request_commit_message

    def initialize
      @cache_dir = Dir.pwd
      @root_dir = Dir.pwd
      @valid_estimates = DEFAULT_VALID_ESTIMATES
      @wip_limit = DEFAULT_WIP_LIMIT
      @repos = []
      @story_handler = nil
      @pull_request_handler = nil
      @pull_request_commit_message = DEFAULT_COMMIT_MESSAGE
      @pull_request_labels = []
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

    def self.load_commands(path=DEFAULT_COMMAND_PATH)
      load_path(path)
    end

    def self.load_handlers(path=DEFAULT_HANDLER_PATH)
      load_path(path)
    end

    def self.load_path(path)
      directory = File.join(Startling::GitLocal.new.project_root, path, "*")
      return unless directory
      Dir.glob(directory).each do |file|
        load "#{file}"
      end
      directory
    end

    def hook_commands
      @hooks ||= HookCommands.new
    end

    class HookCommands
      attr_accessor :before_story_start, :after_story_start,
      :before_pull_request, :create_pull_request, :after_pull_request

      def initialize
        @before_story_start = []
        @after_story_start = []
        @before_pull_request = []
        @after_pull_request = [:label_pull_request]
      end
    end
  end
end
