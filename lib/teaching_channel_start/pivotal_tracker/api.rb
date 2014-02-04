require 'faraday'
require 'json'

module TeachingChannelStart
  module PivotalTracker
    class Api
      def initialize(options = {})
        @api_token = options[:api_token]
        @username = options[:username]
        @password = options[:password]
      end

      def user_id
        get("me")["id"]
      end

      def self.api_token_for_user(username, password)
        connection = Faraday.new("https://www.pivotaltracker.com/services/v5")
        connection.basic_auth(username, password)
        parse_response(connection.get("me"))["api_token"]
      end

      def story(id)
        get("stories/#{id}")
      end

      def update_story(id, attrs)
        response = connection.put do |request|
          request.url "stories/#{id}"
          request.headers["Content-Type"] = "application/json"
          request.headers["X-TrackerToken"] = api_token
          request.body = attrs.to_json
        end

        Api.parse_response response
      end

      private
      attr_reader :username, :password, :api_token

      def connection
        @connection ||= Faraday.new("https://www.pivotaltracker.com/services/v5") do |faraday|
          # faraday.response :logger
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter
        end
      end

      def get(url, options = {})
        response = connection.get do |request|
          request.url url, options
          request.headers["X-TrackerToken"] = api_token
        end

        Api.parse_response response
      end

      def self.parse_response(response)
        verify_response response
        JSON.parse response.body
      end

      def self.verify_response(response)
        return if response.status == 200
        puts "Request to #{url} failed"
        puts response.body
        raise "Request failed"
      end
    end
  end
end
