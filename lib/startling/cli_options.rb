require "optparse"

module Startling
  class CliOptions
    USAGE = <<U
Usage: start [options]

Example:

$ start 12345 my branch name
U
    def self.parse
      options = {story_id: nil, branch_name: nil}
      parser = OptionParser.new do |opts|
        opts.banner = USAGE

        opts.on('-s', '--story story', 'Story id') do |story|
          options[:story_id] = story
        end

        opts.on('-b', '--branch branch', 'Branch name (Can be separated by spaces or dashes.)') do |branch|
          options[:branch_name] = branch
        end
        opts.on('-h', '--help', 'Displays Help') do
          puts opts
          exit
        end
      end
      begin
        parser.parse!
      rescue
        puts parser.help
        exit
      end
      options.merge!({args: ARGV})
    end
  end
end
