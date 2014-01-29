module TchStart
  module Github
    class Repo
      attr_reader :name, :api

      def initialize(name, api)
        @name = name
        @api = api
      end

      def pull_requests
        api.pull_requests(name)
      end

      def self.all
        @all ||= [
          new('TeachingChannel/teaching-channel'),
          new('TeachingChannel/teaching-channel-blog'),
          new('TeachingChannel/teaching-channel-chef'),
        ]
      end
    end
  end
end
