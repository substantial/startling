require_relative 'system_helpers'

module TeachingChannelStart
  module GitHelpers
    include SystemHelpers

    def current_branch
      `git symbolic-ref -q --short HEAD`.strip
    end

    def checkout_branch(branch)
      run "git checkout #{branch}"
    end

    def remote_branches
      run "git branch -r"
    end

    def local_branches
      run "git branch"
    end

    def create_remote_branch(branch, base_branch: 'origin/master')
      run "git fetch -q"
      run "git checkout -q #{branch_name} 2>/dev/null || git checkout -q -b #{branch_name} #{default_branch}"
    end

    def destroy_branch(branch)
      run "git push origin :#{branch}" if remote_branches.include? branch
      run "git branch -D #{branch}" if local_branches.include? branch
    end

    def repo_name
      `git config --get remote.origin.url`[/:(.*)\.git/, 1]
    end
  end
end
