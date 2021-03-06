require 'startling'
require 'highline/import'
require_relative '../../startling_pivotal'

module Startling
  module Commands
    class PivotalStart < Base
      def execute
        Startling::Configuration.load_configuration

        logger.info "Starting story..."
        estimate = ask_for_estimate unless story.estimated?
        story_owners = [StartlingPivotal.user_id]
        story.start(starter_ids: story_owners, estimate: estimate)
        story
      end

      def ask_for_estimate
        logger.info "'#{story.name}' is not estimated."
        valid_estimates = StartlingPivotal.valid_estimates
        begin
          estimate = ask("Enter estimate (#{valid_estimates.join(", ")}): ")
          estimate = Integer(estimate)
          raise 'Invalid estimate' unless valid_estimates.include? estimate
          return  estimate
        rescue => e
          puts e.message
          retry
        end
      end

      def story
        @story ||= StartlingPivotal.story(get_story_id)
      end

      def get_story_id
        if story_id
          story_id
        elsif args.length > 0
          args[0]
        else
          prompt_for_story_id
        end
      end

      private

      def prompt_for_story_id
        result = ask("Enter story id to start: ")
        abort "Pivotal id must be specified." if result.empty?
        result
      end
    end
  end
end
