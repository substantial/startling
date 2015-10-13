module Startling
  module Commands
    class Base
      attr_reader :cli_options

      def self.run(attrs={})
        new(attrs).execute
      end

      def initialize(attrs={})
        @cli_options = attrs
        attrs.each do |attr, value|
          self.class.__send__(:attr_reader, attr)
          instance_variable_set("@#{attr}", value)
        end
      end

      def execute
        raise NotImplementedError
      end

      def self.load_configuration
        loaded_configuration_path = Startling::Configuration.load_configuration
        if loaded_configuration_path
          puts "Loading configuration #{loaded_configuration_path}"
        else
          puts "Using default configuration"
        end
      end

      def self.load_commands
        loaded_commands_path = Startling::Configuration.load_commands
        if loaded_commands_path
          puts "Loading commands #{loaded_commands_path}"
        end
      end

      def self.load_handlers
        loaded_handlers_path = Startling::Configuration.load_handlers
        if loaded_handlers_path
          puts "Loading handlers #{loaded_handlers_path}"
        end
      end

      def handler_class(handler)
        Startling::Handlers.const_get(to_camel_case(handler.to_s))
      end

      def command_class(command)
        Startling::Commands.const_get(to_camel_case(command.to_s))
      end

      def print_args(context)
        puts "== Instance vars from #{context} ==>"
        instance_variables.each do |var|
          puts "#{var}: #{instance_variable_get(var)}"
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
