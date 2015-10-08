require_relative "pull_request_handler_base"

module Startling
  module Handlers
    class DefaultPullRequestHandler < PullRequestHandlerBase
      def title
        story.pull_request_title
      end

      def body
        story.pull_request_body_text
      end

      def commit_message
        Startling.pull_request_commit_message
      end

      def story
        @args.fetch(:story)
      end
    end
  end
end
