require_relative "pull_request_handler_base"

module Startling
  module Handlers
    class DefaultPullRequestHandler < PullRequestHandlerBase
      def title
        title = ask("Please input a pull request title: ")
        abort "Title must be specified." if title.empty?
        title
      end

      def body
        Startling.pull_request_body
      end

      def commit_message
        Startling.pull_request_commit_message
      end
    end
  end
end
