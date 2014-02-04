module TeachingChannelStart
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
        @all ||= TeachingChannelStart::REPOS.map { |name| new(name) }
      end
    end
  end
end
