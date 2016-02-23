require 'highline/import'
require_relative "base"
require_relative "../github"

module Startling
  module Commands
    class CreateBranch < Base
      def execute
        abort "Branch name, #{branch_name}, is not valid" unless valid_branch_name?

        create_branch if branch_name != git.current_branch
        branch_name
      end

      def repo
        @repo ||= Github.repo(git.repo_name)
      end

      def create_branch
        logger.info "Creating branch #{branch_name}..."
        git.create_remote_branch(branch_name, base_branch: "origin/#{default_branch}")
      end

      def default_branch
        repo.default_branch
      end

      def branch_name
        @branch_name ||= get_branch_name
      end

      def valid_branch_name?
        (branch_name != default_branch) && custom_validate_branch_name
      end

      private

      def get_branch_name
        if branch.empty?
          git.current_branch
        else
          "#{branch}".gsub(/\s+/, '-')
        end
      end

      def custom_validate_branch_name
        return true if Startling.validate_branch_name.nil?

        Startling.validate_branch_name.call(branch_name)
      end

      def branch
        @branch ||=
          if args.length > 1
            args[1..-1].map(&:downcase).join('-')
          else
            ask("Enter branch name (enter for current branch): ")
          end
      end
    end
  end
end
