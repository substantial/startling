require_relative "base"

module Startling
  module Commands
    class CreatePullRequest < Base
      def execute
        open_pull_request
      end

      def open_pull_request
        puts "Opening pull request..."
        Shell.run "git commit --allow-empty -m #{Startling.start_commit_message}"
        Shell.run "git push -qu origin HEAD"

        repo.open_pull_request title: 'story.name',
          body: 'story.url', branch: branch_name
      end

      def pull_request_title
        "story.name"
      end
    end
  end
end
