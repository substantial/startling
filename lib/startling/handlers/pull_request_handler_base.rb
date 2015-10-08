module Startling
  module Handlers
    class PullRequestHandlerBase
      def pull_request_labels
        raise NotImplementedError
      end

      def pull_request_title
        raise NotImplementedError
      end

      def pull_request_body
        raise NotImplementedError
      end

      def pull_request_commit_message
        rails NotImplementedError
      end
    end
  end
end
