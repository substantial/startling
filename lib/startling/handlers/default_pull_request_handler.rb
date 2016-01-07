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
        body = ask("Please input a pull request body: (default is empty)")
        body = "" if body.empty?
        body
      end

      def commit_message
        Startling.pull_request_commit_message
      end
    end
  end
end
