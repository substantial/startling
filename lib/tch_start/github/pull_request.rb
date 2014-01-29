module TchStart
  module Github
    class PullRequest
      attr_reader :pull_request

      def initialize(pull_request)
        @pull_request = pull_request
        prefetch_data
      end

      def title
        pull_request.title
      end

      def branch
        pull_request.head.ref
      end

      def in_progress?
        title !~ /^(HOLD|TESTING):/
      end

      def url
        pull_request.rels[:html].href
      end

      def created_at
        pull_request.created_at
      end

      def updated_at
        pull_request.updated_at
      end

      def author
        @author ||= pull_request.user.rels[:self].get.data.name
      end

      private
      def prefetch_data
        author
      end
    end
  end
end
