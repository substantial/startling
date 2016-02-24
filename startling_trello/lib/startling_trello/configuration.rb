require 'startling'

module StartlingTrello
  class Configuration
    DEFAULT_CONFIG_FILE = 'startling_trello_file.rb'

    attr_accessor :developer_public_key

    def initialize
      @developer_public_key = nil
    end

    def self.load_configuration
      file_name = DEFAULT_CONFIG_FILE

      if Dir.entries(Startling::GitLocal.new.project_root).include? file_name
        load "#{Startling::GitLocal.new.project_root}/#{file_name}"
        return file_name
      end

      nil
    end
  end
end
