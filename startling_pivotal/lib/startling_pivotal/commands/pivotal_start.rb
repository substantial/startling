require 'startling'
require_relative '../../startling_pivotal'

module Startling
  module Commands
    class PivotalStart < Base
      VALID_ESTIMATES = [1, 2, 4, 8, 16, 32, 64, 128]

      def execute
        puts "Starting story..."
        estimate = ask_for_estimate unless story.estimated?
        story_owners = [StartlingPivotal.user_id]
        story.start(starter_ids: story_owners, estimate: estimate)
        story
      end

      def ask_for_estimate
        puts "'#{story.name}' is not estimated."
        begin
          estimate = ask("Enter estimate (#{VALID_ESTIMATES.join(", ")}): ")
          estimate = Integer(estimate)
          raise 'Invalid estimate' unless VALID_ESTIMATES.include? estimate
          return  estimate.to_i
        rescue => e
          puts e.message
          retry
        end
      end

      def story
        @story ||= StartlingPivotal.story(get_story_id)
      end

      def get_story_id
        @story_id ||= prompt_for_story_id
      end

      def prompt_for_story_id
        result = ask("Enter story id to start: ")
        abort "Pivotal id must be specified." if result.empty?
        result
      end
    end
  end
end