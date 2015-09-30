require_relative '../work'
require_relative '../work_printer'

require_relative "base"

module Startling
  module Commands
    class CheckWip < Base
      using ColorizeString

      def execute
        puts "Checking WIP..."
        wip = Work.in_progress
        if wip.count >= Startling.wip_limit
          WorkPrinter.new.print wip
          puts
          wiki_link = "https://github.com/TeachingChannel/teaching-channel/wiki/wip".underline.blue
          puts "What to do when WIP'd: #{wiki_link}"
          puts
          question = [
            "Would you like to start anyway (",
            'anything but "yes" will abort'.underline,
            ")? "
          ].map { |string| string.yellow }.join
          confirm = ask(question)

          exit unless confirm == "yes"
        end
      end
    end
  end
end
