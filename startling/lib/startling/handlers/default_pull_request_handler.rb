require 'highline/import'
require_relative "pull_request_handler_base"

module Startling
  module Handlers
    class DefaultPullRequestHandler < PullRequestHandlerBase
      def title
        title = get_title
        abort "Title must be specified." if title.empty?
        title
      end

      def body
        (story) ? get_story_body : Startling.pull_request_body
      end

      def commit_message
        Startling.pull_request_commit_message
      end

      private

      def get_story_body
        "#{story.pull_request_body_text}\n\n#{Startling.pull_request_body}"
      end

      def get_title
        if story
          story.pull_request_title
        else
          title = ask("Please input a pull request title: ")
        end
      end

      def story
        @story ||= @args.fetch(:story)
      end
    end
  end
end
