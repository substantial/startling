require_relative "base"

module Startling
  module Commands
    class CreateBranch < Base
      def execute
        create_branch if branch_name != git.current_branch
        branch_name
      end

      def repo
        @repo ||= Github.repo(git.repo_name)
      end

      def create_branch
        puts "Creating branch #{branch_name}..."
        git.create_remote_branch(branch_name, base_branch: "origin/#{default_branch}")
      end

      def default_branch
        repo.default_branch
      end

      def branch_name
        @branch_name ||= get_branch_name
      end

      def get_branch_name
        if branch.empty?
          if git.current_branch_is_a_feature_branch?
            return git.current_branch
          else
            abort "Branch name must be specified when current branch is not feature/."
          end
        end

        branch.gsub!(/feature\//, '')
        "feature/#{branch}".gsub(/\s+/, '-')
      end

      private

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
