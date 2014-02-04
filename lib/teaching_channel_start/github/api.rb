require 'parallel'
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
        repositories[name] ||= Repo.new(name, self)
      end

      private
      attr_reader :lock, :repositories

      def octokit
        lock.synchronize do
          @octokit ||= build_octokit
        end
      end

      def build_octokit
        stack = Faraday::RackBuilder.new do |builder|
          #builder.response :logger
          builder.use Octokit::Response::RaiseError
          builder.adapter Faraday.default_adapter
        end
        Octokit.middleware = stack
        Octokit::Client.new access_token: access_token
      end

      def access_token
        TeachingChannelStart.cache.fetch('.github_access_token') do
          begin
            Octokit::Client.new(login: prompt_for_login, password: prompt_for_password)
              .create_authorization(scopes: ["repo"])[:token]
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
    end
  end
end
