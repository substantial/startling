module Startling
  module Handlers
    class PullRequestHandlerBase
      def initialize(args)
        @args = args
      end

      def title
        raise NotImplementedError
      end

      def body
        raise NotImplementedError
      end

      def commit_message
        raise NotImplementedError
      end
    end
  end
end
