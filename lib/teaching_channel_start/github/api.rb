require 'parallel'
require 'faraday'
require_relative 'pull_request'

module TeachingChannelStart
  module Github
    class Api
      def initialize
        @lock = Mutex.new
        @repositories = {}
      end

      def pull_requests(repo)
        raw = octokit.pull_requests(repo, state: 'open')
        Parallel.map(raw, in_threads: raw.count) do |pull|
          PullRequest.new(pull).tap do |pull_request|
            pull_request.labels = labels_for_issue(repo_name: repo, issue_id: pull_request.id)
          end
        end
      end

      def repository(name)
        Repo.new name, self
      end

      def repository_attributes(name)
        octokit.repository(name)
      end

      def open_pull_request(title: nil, body: nil, branch: nil,
        destination_branch: nil, repo_name: nil)
        response = octokit.create_pull_request(repo_name, destination_branch, branch, title, body)
        response.data
      rescue Octokit::UnprocessableEntity => e
        puts "Failed to open pull request, it may be open already"
        p e
        nil
      end

      def labels_for_issue(repo_name: nil, issue_id: nil)
        octokit.labels_for_issue(repo_name, issue_id)
      end

      def set_labels_for_issue(repo_name: nil, issue_id: nil, labels: nil)
        octokit.replace_all_labels(repo_name, issue_id, labels)
      end

      def pull_request(repo_name, branch)
        repository(repo_name).pull_request(branch)
      end

      private
      attr_reader :lock, :repositories

      def octokit
        lock.synchronize do
          @octokit ||= build_octokit
        end
      end

      def build_octokit
        stack = faraday_builder_class.new do |builder|
          #builder.response :logger
          builder.use Octokit::Response::RaiseError
          builder.adapter Faraday.default_adapter
        end
        Octokit.middleware = stack
        Octokit::Client.new access_token: access_token
      end

      def faraday_builder_class
        defined?(Faraday::RackBuilder) ? Faraday::RackBuilder : Faraday::Builder
      end

      def access_token
        TeachingChannelStart.cache.fetch('.github_access_token') do
          client = Octokit::Client.new(login: prompt_for_login, password: prompt_for_password)
          authorization_opts = {}
          authorization_opts[:scopes] = ["repo"]
          authorization_opts[:note] = "teaching-channel-start on #{`echo $HOSTNAME`}"
          begin
            client.create_authorization(authorization_opts)[:token]
          rescue Octokit::OneTimePasswordRequired
            authorization_opts[:headers] = { "X-GitHub-OTP" => prompt_for_otp }
            retry
          rescue Octokit::Unauthorized
            puts "Invalid username or password, try again."
            retry
          end
        end
      end

      def prompt_for_login
        ask("Enter your Github username:  ")
      end

      def prompt_for_password
        ask("Enter your Github password:  ") { |q| q.echo = false }
      end

      def prompt_for_otp
        ask("Enter your one time password:  ")
      end
    end
  end
end
