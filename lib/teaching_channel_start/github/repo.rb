module TeachingChannelStart
  module Github
    class Repo
      attr_reader :api, :name

      def initialize(name, api)
        @name = name
        @api = api
      end

      def attributes
        @attributes ||= api.repository_attributes(name)
      end

      def default_branch
        attributes.default_branch
      end

      def pull_requests
        @pull_requests ||= api.pull_requests(name)
      end

      def pull_request(branch)
        pull_requests.find { |pr| pr.branch == branch }
      end

      def set_labels_for_issue(issue_id:, labels:)
        labels = Array(labels)
        api.set_labels_for_issue(repo_name: name, issue_id: issue_id, labels: labels)
      end

      def open_pull_request(title: nil, body: nil, branch: nil)
        pull_request = api.open_pull_request(repo_name: name, destination_branch: default_branch,
          branch: branch, title: title, body: body)
        return pull_request if pull_request
        pull_request(branch) # In case this is already open
      end

      def self.all
        @all ||= TeachingChannelStart::REPOS.map { |name| new(name) }
      end
    end
  end
end
