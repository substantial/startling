
module TeachingChannelStart
  module Commands
    class StartStory
      attr_reader :story, :pivotal_tracker

      def initialize(options={})
        @story = options.fetch(:story)
        @pivotal_tracker = options.fetch(:pivotal_tracker)
      end

      def call
        puts "Starting story..."
        estimate = ask_for_estimate unless story.estimated?
        story.start(starter_id: pivotal_tracker.user_id, estimate: estimate)
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
