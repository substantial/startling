require_relative "base"

module Startling
  module Commands
    class LabelPullRequest < Base
      def execute
        repo.set_labels_for_issue issue_id: pull_request.id, labels: Startling.pull_request_labels
      end

      def repo
        Github.repo(git.repo_name)
      end
    end
  end
end
