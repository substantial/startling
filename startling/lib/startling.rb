require 'startling/command'
require 'startling/cli_options'
require 'startling/cache'
require 'startling/configuration'

# Optionally load plugins
begin
  require 'startling-pivotal'
rescue LoadError
end

module Startling
  class << self
    attr_writer :configuration

    def method_missing(method, *args, &block)
      configuration.send(method, *args, &block)
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset
    @configuration =  Configuration.new
  end

  def self.cache
    @cache ||= Cache.new(configuration.cache_dir)
  end
end
