require 'spec_helper'
require 'startling_trello/story'

module StartlingTrello
  describe Story do
    let(:card) do
      double(:card,
        name: 'Card name',
        short_url: 'Card url'
      )
    end

    let(:story) { Story.new(card) }

    it 'returns the pull request title' do
      expect(story.pull_request_title).to eq(card.name)
    end

    it 'returns the pull request body' do
      expect(story.pull_request_body_text).to eq(card.short_url)
    end
  end
end
