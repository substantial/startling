require_relative 'pivotal_tracker/story'
require_relative 'pivotal_tracker/helper'
require_relative 'pivotal_tracker/api'

module Startling
  class PivotalTracker
    attr_reader :api_token
    def initialize(api_token)
      @api_token = api_token
    end

    def api
      @api ||= PivotalTracker::Api.new(api_token: api_token)
    end

    def user_id
      @user_id ||= begin
        api.user_id
      end
    end

    def story(id)
      PivotalTracker::Story.new(id, api)
    end
  end
end
