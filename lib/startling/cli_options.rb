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

        opts.on('-s', '--story_id story_id', 'Story id') do |story_id|
          options[:story_id] = story_id
        end

        opts.on('-b', '--branch branch', 'Branch name (Can be separated by spaces or dashes.)') do |branch|
          options[:branch_name] = branch
        end

        Startling.cli_options.each do |option|
          opts.on(option.abbr_switch, option.long_switch, option.description) do |value|
            options[option.full_switch.to_sym] = value
          end
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
