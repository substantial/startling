require_relative 'shell'

module TeachingChannelStart
  class GitLocal
    def self.current_branch
      `git symbolic-ref -q --short HEAD`.strip
    end

    def self.checkout_branch(branch)
      Shell.run "git checkout #{branch}"
    end

    def self.remote_branches
      Shell.run "git branch -r"
    end

    def self.local_branches
      Shell.run "git branch"
    end

    def self.create_remote_branch(branch_name, base_branch: 'origin/master')
      Shell.run "git fetch -q"
      Shell.run "git checkout -q #{branch_name} 2>/dev/null || git checkout -q -b #{branch_name} #{base_branch}"
    end

    def self.destroy_branch(branch)
      Shell.run "git push origin :#{branch}" if remote_branches.include? branch
      Shell.run "git branch -D #{branch}" if local_branches.include? branch
    end

    def self.repo_name
      `git config --get remote.origin.url`[/:(.*)\.git/, 1]
    end

    def self.current_branch_is_a_feature_branch?
       current_branch =~ %r{^feature/}
    end
  end
end
