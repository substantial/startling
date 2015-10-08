require_relative "pull_request_handler_base"

module Startling
  module Handlers
    class DefaultPullRequestHandler < PullRequestHandlerBase
      def pull_request_labels
        Startling.valid_estimates
      end

      def pull_request_title
        "Some title"
      end

      def pull_request_body
        "Some body"
      end

      def pull_request_commit_message
        Startling.pull_request_commit_message
      end
    end
  end
end
