require 'startling'
require 'highline/import'
require_relative '../../startling_trello'

module Startling
  module Commands
    class TrelloStart < Base
      def execute
        StartlingTrello::Configuration.load_configuration

        api = StartlingTrello.api

        card = api.find_card(get_card_id)
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
        result = ask("Enter card id to start: ")
        abort "Card id must be specified." if result.empty?
        result
      end
    end
  end
end
