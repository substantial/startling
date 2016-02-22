require 'startling/git_local'
require 'startling/github'
require 'startling/colorize_string'
require 'startling/commands/check_wip'
require 'startling/commands/label_pull_request'
require 'startling/handlers/default_pull_request_handler'

module Startling
  class Configuration
    DEFAULT_COMMAND_PATH = "startling/commands"
    DEFAULT_HANDLER_PATH = "startling/handlers"
    DEFAULT_WIP_LIMIT = 4
    DEFAULT_COMMIT_MESSAGE = "Startling"
    DEFAULT_BODY = "Startling"

    DEFAULT_STARTLINGFILES = [
      'startlingfile.rb',
      'Startlingfile.rb'
    ].freeze

    attr_accessor :cache_dir, :root_dir, :wip_limit, :wip_labels, :repos, :story_handler,
      :validate_branch_name, :pull_request_body, :pull_request_handler,
      :pull_request_labels, :pull_request_commit_message, :cli_options

    def initialize
      @cache_dir = Dir.pwd
      @root_dir = Dir.pwd
      @wip_limit = DEFAULT_WIP_LIMIT
      @wip_labels = []
      @repos = [GitLocal.new.repo_name]
      @story_handler = nil
      @validate_branch_name = nil
      @pull_request_handler = nil
      @pull_request_body = DEFAULT_BODY
      @pull_request_commit_message = DEFAULT_COMMIT_MESSAGE
      @pull_request_labels = []
      @cli_options = []
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

    def add_cli_option(abbr_switch, full_switch, description, required=false)
      @cli_options << CliOption.new(abbr_switch, full_switch, description, required)
    end

    def cli_options
      @cli_options ||= []
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

    class CliOption
      attr_reader :abbr_switch, :description, :full_switch

      def initialize(abbr_switch, full_switch, description, required)
        @abbr_switch = abbr_switch
        @full_switch = full_switch
        @description = description
        @required = required
      end

      def long_switch
        @required ? "--#{@full_switch} #{@full_switch}" : "--#{@full_switch}"
      end

      def sym
        full_switch.to_s
      end
    end
  end
end
