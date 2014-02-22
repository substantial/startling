module TeachingChannelStart
  class UsageHelp
    def self.print
      puts "Usage:

    $ script/start <story id> <branch name>

    <story id>: Pivotal story id
    <branch name>: Branch name without feature/. Can be separated by spaces or dashes.

    Example:

    $ script/start 12345 my favorite feature"
    end
  end
end
