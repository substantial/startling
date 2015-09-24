module Startling
  class PivotalTracker
    class Helper
      def pivotal_api_token
        @pivotal_api_token ||= Startling.cache.fetch('.pivotal_api_token') do
          username = ask("Enter your Pivotal Tracker username:  ")
          password = ask("Enter your Pivotal Tracker password:  ") { |q| q.echo = false }
          PivotalTracker::Api.api_token_for_user(username, password)
        end
      end
      alias_method :set_pivotal_api_token, :pivotal_api_token
    end
  end
end
