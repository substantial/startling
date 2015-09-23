require_relative 'startling/command'
require 'startling/configuration'

module Startling
  class << self
    attr_writer :configuration

    def method_missing(method, *args, &block)
      configuration.send(method)
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
