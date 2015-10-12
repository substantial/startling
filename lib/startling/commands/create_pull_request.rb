require_relative "base"
require_relative 'create_branch'

module Startling
  module Commands
    class CreatePullRequest < Base
      def execute
        create_branch
        open_pull_request
      end

      def create_branch
        @branch_name ||= CreateBranch.run(args: args, git: git)
      end

      def open_pull_request
        puts "Opening pull request..."
        git.create_empty_commit(pull_request_handler.commit_message)
        git.push_origin_head

        repo.open_pull_request title: pull_request_handler.title,
          body: pull_request_handler.body, branch: @branch_name
      end

      def repo
        @repo ||= Github.repo(git.repo_name)
      end

      def pull_request_handler
        handler_name = Startling.pull_request_handler || :default_pull_request_handler
        handler_class(handler_name).new(cli_options)
      end
    end
  end
end
