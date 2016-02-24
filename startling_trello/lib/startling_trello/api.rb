require 'trello'

module StartlingTrello
  class Api
    def initialize(developer_public_key:, member_token:)
      @client = Trello::Client.new(
        developer_public_key: developer_public_key,
        member_token: member_token
      )
    end

    def find_card(card_id)
      begin
        @client.find(:card, card_id)
      rescue Trello::Error
        abort 'Invalid card id: Card could not be found'
      end
    end
  end
end
