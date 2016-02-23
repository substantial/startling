require 'rails/generators'
require 'rails/generators/base'

module StartlingPivotal
  module Generators
    class ConfigurationGenerator < Rails::Generators::Base
      def create_config_file
        create_file "startling_pivotal_file.rb" do
<<CONFIG
StartlingPivotal.configure do |config|
  # Valid story estimations
  # config.valid_estimates = [1, 2, 4, 8, 16, 32, 64, 128]
end
CONFIG
        end
      end
    end
  end
end
