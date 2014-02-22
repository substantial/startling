module GitHelpers
  def current_branch
    `git symbolic-ref -q --short HEAD`.strip
  end

  def checkout_branch(branch)
    `git checkout #{branch}`
  end

  def remote_branches
    `git branch -r`
  end

  def local_branches
    `git branch`
  end

  def create_remote_branch(branch)
    `git push origin master:#{branch}`
  end

  def destroy_branch(branch)
    `git push origin :#{branch}` if remote_branches.include? branch
    `git branch -D #{branch}` if local_branches.include? branch
  end
end
