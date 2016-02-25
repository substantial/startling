require 'startling'

module StartlingTrello
  class Story < Startling::Story
    attr_accessor :card

    def initialize(card)
      @card = card
    end

    def pull_request_title
      card.name
    end

    def pull_request_body_text
      card.url
    end
  end
end
