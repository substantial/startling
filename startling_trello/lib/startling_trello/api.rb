require 'trello'

module StartlingTrello
  class Api
    def initialize(developer_public_key:, member_token:)
      @member_token = member_token
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

    def find_list(list_id)
      begin
        @client.find(:list, list_id)
      rescue Trello::Error
        abort 'Invalid list id: List could not be found'
      end
    end

    def find_board(board_id)
      begin
        @client.find(:board, board_id)
      rescue Trello::Error
        abort 'Invalid board id: Board could not be found'
      end
    end

    def move_card_to_list(card:, list:)
      card.move_to_list(list)
    end

    def add_member_to_card(card)
      begin
        card.add_member(get_member_from_token)
      rescue Trello::Error
        # Member is already on card
      end
    end

    def get_member_from_token
      token = @client.find(:token, @member_token)
      @client.find(:member, token.member_id)
    end
  end
end
