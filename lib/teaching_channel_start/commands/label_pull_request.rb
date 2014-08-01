require_relative "base"

module TeachingChannelStart
  module Commands
    class LabelPullRequest < Base
      def execute
        repo.set_labels_for_issue issue_id: pull_request.id, labels: labels
      end
    end
  end
end
