module StartlingPivotal
  class Configuration
    DEFAULT_VALID_ESTIMATES = [1, 2, 4, 8, 16, 32, 64, 128]
    DEFAULT_CONFIG_FILE = 'startling_pivotal_file.rb'

    attr_accessor :valid_estimates

    def initialize
      @valid_estimates = DEFAULT_VALID_ESTIMATES
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
