require_relative '../work'
require_relative '../work_printer'

module TeachingChannelStart
  module Commands
    class CheckWip
      def call
        puts "Checking WIP..."
        wip = Work.in_progress
        if wip.count >= WIP_LIMIT
          WorkPrinter.new.print wip
          puts
          question = [
            "Would you like to continue to add to that (",
            "anything but \"yes\" will abort".underline,
            ")? "
          ].map(&:yellow).join
          confirm = ask(question)

          exit unless confirm == "yes"
        end
      end
    end
  end
end
