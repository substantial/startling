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
        Parallel.map(raw, in_threads: raw.count) { |pull| PullRequest.new(pull) }
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
          begin
            Octokit::Client.new(login: prompt_for_login, password: prompt_for_password)
              .create_authorization(scopes: ["repo"], note: token_description)[:token]
          rescue Octokit::Unauthorized
            puts "Invalid username or password, try again."
            retry
          rescue => e
            p e
          end
        end
      end

      def token_description
        Shell.run "echo $HOSTNAME"
      end

      def prompt_for_login
        ask("Enter your Github username:  ")
      end

      def prompt_for_password
        ask("Enter your Github password:  ") { |q| q.echo = false }
      end
    end
  end
end
