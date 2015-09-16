require 'paint'
require_relative './time_format_helpers'
require_relative "./colorize_string"

module Startling
  class WorkPrinter
    using ColorizeString
    include TimeFormatHelpers

    def print(works)
      puts works.sort_by(&:started_at).map { |work| format_work(work) }.join("\n\n")
      puts "\nThere is currently #{count(works)} out of #{Startling.wip_limit.to_s.yellow} WIP."
    end

    def format_pull_request(pull_request)
      "#{format_pull_request_labels(pull_request)}: #{pull_request.title}\n" +
        "  Started #{ago pull_request.created_at}, last updated #{ago pull_request.updated_at}\n" +
        "  #{pull_request.url.cyan.underline}"
    end

    def format_work(work)
      "#{work.authors.join(", ").green} - #{work.branch.to_s.yellow}\n".yellow +
        indent(work.pull_requests.sort_by(&:created_at).map { |p| format_pull_request(p) }.join("\n"))
    end

    def indent(string)
      string.split("\n").map {|s| "  #{s}"}.join("\n")
    end

    def ago(time)
      business_time_ago(time).yellow
    end

    def count(works)
      count = works.count
      case count
      when ->(c) { c > Startling.wip_limit }
        count.to_s.red
      when ->(c) { c == Startling.wip_limit }
        count.to_s.yellow
      else
        count.to_s.blue
      end
    end

    private
    def format_pull_request_labels(pull_request)
      pull_request.labels.map do |label|
        Paint[label[:name], :black, label[:color]]
      end.join(", ")
    end
  end
end
