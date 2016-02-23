require 'logger'

module Startling
  module Commands
    class Base
      attr_reader :cli_options, :logger

      def self.run(attrs={})
        new(attrs).execute
      end

      def initialize(attrs={})
        @cli_options = attrs
        attrs.each do |attr, value|
          self.class.__send__(:attr_reader, attr)
          instance_variable_set("@#{attr}", value)
        end

        @logger = Logger.new(STDOUT)
        @logger.formatter = -> (severity, datetime, progname, msg) { "#{msg}\n" }
        @logger.level = (attrs[:verbose]) ? Logger::DEBUG : Logger::INFO
      end

      def execute
        raise NotImplementedError
      end

      def load_configuration
        loaded_configuration_path = Startling::Configuration.load_configuration
        if loaded_configuration_path
          logger.debug "Loading configuration #{loaded_configuration_path}"
        else
          logger.debug "Using default configuration"
        end
      end

      def load_commands
        loaded_commands_path = Startling::Configuration.load_commands
        if loaded_commands_path
          logger.debug "Loading commands #{loaded_commands_path}"
        end
      end

      def load_handlers
        loaded_handlers_path = Startling::Configuration.load_handlers
        if loaded_handlers_path
          logger.debug "Loading handlers #{loaded_handlers_path}"
        end
      end

      def handler_class(handler)
        begin
          Startling::Handlers.const_get(to_camel_case(handler.to_s))
        rescue NameError
          print_name_error_message(handler, Startling::Configuration::DEFAULT_HANDLER_PATH)
          exit
        end
      end

      def command_class(command)
        begin
          Startling::Commands.const_get(to_camel_case(command.to_s))
        rescue NameError
          print_name_error_message(command, Startling::Configuration::DEFAULT_COMMAND_PATH)
          exit
        end
      end

      def print_name_error_message(name, path)
        logger.fatal "Error loading #{to_camel_case(name.to_s)}. Is it defined in #{path}?"
      end

      def print_args(context)
        logger.debug "== Instance vars from #{context} ==>"
        instance_variables.each do |var|
          logger.debug "#{var}: #{instance_variable_get(var)}"
        end
      end

      def to_camel_case(lower_case_and_underscored_word, first_letter_in_uppercase = true)
        if first_letter_in_uppercase
          lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
        else
          lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
        end
      end
    end
  end
end
