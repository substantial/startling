require 'startling'
require 'highline/import'
require_relative '../../startling_trello'

module Startling
  module Commands
    class TrelloStart < Base
      def execute
        StartlingTrello::Configuration.load_configuration
        doing_list_id = get_doing_list_id

        api = StartlingTrello.api

        card = api.find_card(get_card_id)
        list = api.find_list(doing_list_id)
        api.move_card_to_list(card: card, list: list)
        api.add_member_to_card(card)
      end

      def get_card_id
        if story_id
          story_id
        elsif args.length > 0
          args[0]
        else
          prompt_for_card_id
        end
      end

      private

      def prompt_for_card_id
        result = ask('Enter card id to start: ')
        abort 'Card id must be specified.' if result.empty?
        result
      end

      def get_doing_list_id
        doing_list_id = StartlingTrello.doing_list_id
        abort 'Doing list id must be specified in configuration.' if doing_list_id.nil?
        doing_list_id
      end
    end
  end
end
