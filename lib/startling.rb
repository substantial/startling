require_relative 'startling/command'
require 'startling/configuration'

module Startling
  class << self
    attr_writer :configuration
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

#  def self.cache_dir
#    @cache_dir or raise "set cache_dir="
#  end
#
#  def self.root_dir
#    @root_dir or raise "set root_dir="
#  end
#
  def self.cache
    @cache ||= Cache.new(configuration.cache_dir)
  end
end
