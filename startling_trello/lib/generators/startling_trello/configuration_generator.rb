require 'rails/generators'
require 'rails/generators/base'
require 'startling'

module StartlingTrello
  module Generators
    class ConfigurationGenerator < Rails::Generators::Base
      def create_config_file
        generate 'startling:configuration'

        file_name = Startling::Configuration::DEFAULT_STARTLINGFILES[0]

        inject_into_file file_name, before: 'Startling.configure do |config|' do
<<CONFIG
require 'startling_trello'

CONFIG
        end

        gsub_file file_name,
          '# config.story_handler = :pivotal_start',
          'config.story_handler = :trello_start'

        inject_into_file file_name, after: 'config.story_handler = :trello_start' do
<<CONFIG


  # Trello Developer API key
  # config.developer_public_key = 'developer-public-key'

  # Trello Doing List ID
  # config.doing_list_id = 'doing-list-id'
CONFIG
        end
      end
    end
  end
end
