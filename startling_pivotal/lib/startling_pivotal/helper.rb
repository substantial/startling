require 'startling'
require_relative 'api'

module StartlingPivotal
  class Helper
    def api_token
      @api_token ||= Startling.cache.fetch('.pivotal_api_token') do
        username = ask("Enter your Pivotal Tracker username:  ")
        password = ask("Enter your Pivotal Tracker password:  ") { |q| q.echo = false }
        Api.api_token_for_user(username, password)
      end
    end
  end
end
