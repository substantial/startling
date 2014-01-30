module TeachingChannelStart
  module PivotalTracker
    class Client
      class << self
        attr_accessor :__token
      end

      def self.token(*args)
        return self.__token if args.empty?

        username, password = *args

        self.__token = fetch_token(username, password) if self.__token.nil?

        self.__token
      end

      def self.token=(new_token)
        self.__token = new_token
      end

      def self.fetch_token(username, password)
        response = `curl -s -u #{username}:#{password} -X GET https://www.pivotaltracker.com/services/v5/me`

        JSON.parse(response)["api_token"]
      end
    end
  end
end
