require 'highline/import'
require_relative 'base'
require_relative '../colorize_string'
require_relative '../work'
require_relative '../work_printer'

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
