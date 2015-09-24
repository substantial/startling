module Startling
  module Commands
    class Base
      def self.run(attrs={})
        new(attrs).execute
      end

      def initialize(attrs={})
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

      def self.load_hook_commands
        loaded_commands_path = Startling::Configuration.load_hook_commands
        if loaded_commands_path
          puts "Loading commands #{loaded_commands_path}"
        end
      end
    end
  end
end
