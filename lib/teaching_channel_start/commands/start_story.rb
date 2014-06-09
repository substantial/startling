require_relative "base"

module TeachingChannelStart
  module Commands
    class StartStory < Base
      def execute
        puts "Starting story..."
        estimate = ask_for_estimate unless story.estimated?
        story_owners = [pivotal_tracker.user_id]
        story.start(starter_ids: story_owners, estimate: estimate)
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
    end
  end
end
