module Startling
  module Commands
    class Base
      attr_reader :run_args

      def self.run(attrs={})
        new(attrs).execute
      end

      def initialize(attrs={})
        @run_args = attrs
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
        Startling::Handlers.const_get(handler.to_s.camelize)
      end

      def command_class(command)
        Startling::Commands.const_get(command.to_s.camelize)
      end
    end
  end
end
