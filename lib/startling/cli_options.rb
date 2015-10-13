require "optparse"

module Startling
  class CliOptions
    USAGE = <<USE
Usage: start [options]

Example:

$ start 12345 my branch name
USE
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

        Startling.cli_options.each do |user_opt|
          options.merge!(user_opt.sym => nil)
          opts.on(user_opt.abbr_switch, user_opt.long_switch, user_opt.description) do |value|
            options[user_opt.sym] = value
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
