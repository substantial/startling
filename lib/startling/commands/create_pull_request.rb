require_relative "base"

module Startling
  module Commands
    class CreatePullRequest < Base
      def execute
        pull_request = open_pull_request
        amend_commit_with_pull_request(pull_request.url)
        pull_request
      end

      def open_pull_request
        puts "Opening pull request..."
        Shell.run "git push -qu origin HEAD > /dev/null"

        repo.open_pull_request title: 'story.name',
          body: 'story.url', branch: branch_name
      end

      def pull_request_path
        File.join(Startling.root_dir, Startling.pull_request_filename)
      end

      def pull_request_title
        "story.name"
      end

      def amend_commit_with_pull_request(url)
        File.open(pull_request_path, "a") do |file|
          file.puts url
        end

        Shell.run "git add #{pull_request_path}"
        Shell.run "git commit -q --amend --reuse-message=HEAD"
        Shell.run "git push -qf origin HEAD"
      end
    end
  end
end
