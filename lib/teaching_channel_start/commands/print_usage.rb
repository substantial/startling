require_relative "base"

module TeachingChannelStart
  module Commands
    class PrintUsage < Base
      def execute
        if args[0] == '--help' || args[0] == '-h'
          print
          exit 0
        end
      end

      def print
        puts "Usage:

    $ script/start <story id> <branch name>

    <story id>: Pivotal story id
    <branch name>: Branch name without feature/. Can be separated by spaces or dashes.

    Example:

    $ script/start 12345 my favorite feature"
      end
    end
  end
end
