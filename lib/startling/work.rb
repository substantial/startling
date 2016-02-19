require 'parallel'
require_relative 'github'

module Startling
  class Work
    using ColorizeString

    attr_reader :pull_requests, :branch

    def initialize(branch, pull_requests)
      @branch = branch
      @pull_requests = pull_requests
    end

    def in_progress?
      pull_requests.any?(&:in_progress?)
    end

    def to_s
      "#{authors.join(", ").blue} - #{branch.to_s.yellow}\n" +
        pull_requests.map { |p| "    #{p}"}.join("\n")
    end

    def authors
      pull_requests.map(&:author).uniq.sort
    end

    def started_at
      pull_requests.map(&:created_at).min
    end

    def self.all
      repos = Startling.repos.map { |name| Github.repo(name) }
      pull_requests = Parallel.map(repos, in_threads: repos.count, &:pull_requests).flatten
      from_pull_requests(pull_requests)
    end

    def self.from_pull_requests(pull_requests)
      work = pull_requests.group_by(&:branch)
      work.map { |branch, pulls| new(branch, pulls) }
    end

    def self.in_progress
      all.select(&:in_progress?)
    end
  end
end
