require_relative 'shell'

module Startling
  class GitLocal
    def current_branch
      `git symbolic-ref -q --short HEAD`.strip
    end

    def checkout_branch(branch)
      Shell.run "git checkout #{branch}"
    end

    def status
      Shell.run "git status --porcelain"
    end

    def remote_branches
      Shell.run "git branch -r"
    end

    def local_branches
      Shell.run "git branch"
    end

    def create_remote_branch(branch_name, base_branch: 'origin/master')
      Shell.run "git fetch -q"
      Shell.run "git checkout -q #{branch_name} 2>/dev/null || git checkout -q -b #{branch_name} #{base_branch}"
    end

    def destroy_branch(branch)
      Shell.run "git push origin :#{branch}" if remote_branches.include? branch
      Shell.run "git branch -D #{branch}" if local_branches.include? branch
    end

    def repo_name
      remote_url[%r{([^/:]+/[^/]+)\.git}, 1]
    end

    def current_branch_is_a_feature_branch?
       current_branch =~ %r{^feature/}
    end

    def project_root
       Shell.run "git rev-parse --show-toplevel"
    end

    private

    def remote_url
      `git config --get remote.origin.url`.strip
    end
  end
end
