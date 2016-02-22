module StartlingPivotal
  class PivotalTracker
    class Helper
      def api_token
        @api_token ||= Startling.cache.fetch('.pivotal_api_token') do
          username = ask("Enter your Pivotal Tracker username:  ")
          password = ask("Enter your Pivotal Tracker password:  ") { |q| q.echo = false }
          PivotalTracker::Api.api_token_for_user(username, password)
        end
      end
    end
  end
end
