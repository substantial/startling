require 'rails/generators'
require 'rails/generators/base'
require 'startling'

module StartlingPivotal
  module Generators
    class ConfigurationGenerator < Rails::Generators::Base
      def create_config_file
        create_file "startling_pivotal_file.rb" do
<<CONFIG
StartlingPivotal.configure do |config|
  # Valid story estimations
  # config.valid_estimates = [1, 2, 3]
end
CONFIG
        end

        Startling::Configuration::DEFAULT_STARTLINGFILES.each do |file_name|
          if Dir.entries(Startling::GitLocal.new.project_root).include? file_name
            inject_into_file file_name, before: 'Startling.configure do |config|' do
<<CONFIG
require 'startling_pivotal'

CONFIG
            end

            gsub_file file_name,
              '# config.story_handler = :pivotal_start',
              'config.story_handler = :pivotal_start'
          end
        end
      end
    end
  end
end
