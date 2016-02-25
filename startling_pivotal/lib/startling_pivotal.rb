require 'startling'
require_relative 'startling_pivotal/api'
require_relative 'startling_pivotal/helper'
require_relative 'startling_pivotal/story'
require_relative 'startling_pivotal/commands/pivotal_start'

module StartlingPivotal
  class << self
    def method_missing(method, *args, &block)
      Startling.send(method, *args, &block)
    end
  end

  def self.api
    @api ||= Api.new(api_token: Helper.new.api_token)
  end

  def self.user_id
    @user_id ||= begin
      api.user_id
    end
  end

  def self.story(id)
    Story.new(id, api)
  end
end
