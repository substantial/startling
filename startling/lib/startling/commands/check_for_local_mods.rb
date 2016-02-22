require_relative '../git_local'

require_relative "base"

module Startling
  module Commands
    class CheckForLocalMods < Base
      def execute
        return if git.status.empty?

        puts "Local modifications detected, please stash or something."
        system("git status -s")
        exit 1
      end
    end
  end
end
