require 'rails/generators'
require 'rails/generators/base'
require 'startling'

module StartlingPivotal
  module Generators
    class ConfigurationGenerator < Rails::Generators::Base
      def create_config_file
        generate 'startling:configuration'

        file_name = Startling::Configuration::DEFAULT_STARTLINGFILES[0]

        inject_into_file file_name, before: 'Startling.configure do |config|' do
<<CONFIG
require 'startling_pivotal'

CONFIG
        end

        gsub_file file_name,
          '# config.story_handler = :pivotal_start',
          'config.story_handler = :pivotal_start'

        inject_into_file file_name, after: 'config.story_handler = :pivotal_start' do
<<CONFIG


  # Valid story estimations
  # config.valid_estimates = [1, 2, 3]
CONFIG
        end
      end
    end
  end
end
