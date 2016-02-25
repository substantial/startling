require 'rails/generators'
require 'rails/generators/base'
require 'startling'
require 'startling_trello'

module StartlingTrello
  module Generators
    class ConfigurationGenerator < Rails::Generators::Base
      def create_config_file
        create_file StartlingTrello::Configuration.DEFAULT_CONFIG_FILE do
<<CONFIG
StartlingTrello.configure do |config|
  # Trello Developer API key
  # config.developer_public_key = 'developer-public-key'

  # Trello Doing List ID
  # config.doing_list_id = 'doing-list-id'
end
CONFIG
        end

        Startling::Configuration::DEFAULT_STARTLINGFILES.each do |file_name|
          if Dir.entries(Startling::GitLocal.new.project_root).include? file_name
            inject_into_file file_name, before: 'Startling.configure do |config|' do
<<CONFIG
require 'startling_trello'

CONFIG
            end

            gsub_file file_name,
              '# config.story_handler = :pivotal_start',
              'config.story_handler = :trello_start'
          end
        end
      end
    end
  end
end
