require_relative './time_format_helpers'

module TchStart
  class WorkPrinter
    include TimeFormatHelpers

    def print(works)
      puts works.sort_by(&:started_at).map { |work| format_work(work) }.join("\n\n")
      puts "\nThere is currently #{count(works)} out of #{WIP_LIMIT.to_s.yellow} WIP."
    end

    def format_pull_request(pull_request)
      "#{pull_request.title.sub(/^.*?:/) { |m| m.red }} (#{pull_request.url.cyan.underline})\n" +
        "  Started #{ago pull_request.created_at}, last updated #{ago pull_request.updated_at}"
    end

    def format_work(work)
      "#{work.authors.join(", ").blue} - #{work.branch.to_s.yellow}\n".yellow +
        indent(work.pull_requests.sort_by(&:created_at).map { |p| format_pull_request(p) }.join("\n"))
    end

    def indent(string)
      string.split("\n").map {|s| "  #{s}"}.join("\n")
    end

    def ago(time)
      "#{format_time(time)} ago".yellow
    end

    def count(works)
      count = works.count
      case count
      when ->(c) { c > WIP_LIMIT }
        count.to_s.red
      when ->(c) { c == WIP_LIMIT }
        count.to_s.yellow
      else
        count.to_s.blue
      end
    end
  end
end
