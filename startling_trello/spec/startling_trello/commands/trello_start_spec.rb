require 'spec_helper'
require 'startling_trello/commands/trello_start'

module Startling
  module Commands
    describe TrelloStart do
      let(:card_id) { '123abc' }
      let(:card_url) { 'https://trello.com/c/123abc' }
      let(:attrs) { { story_id: card_url } }
      let(:trello_start) { TrelloStart.new(attrs) }

      describe '#execute' do
        let(:doing_list_id) { 'doing-list-id' }
        let(:card) { double(:card) }
        let(:list) { double(:list) }
        let(:story) { double(:story) }
        let(:api) do
          double(:api,
            find_card: card,
            find_list: list,
            move_card_to_list: true,
            add_member_to_card: true
          )
        end

        before do
          allow(StartlingTrello).to receive(:doing_list_id) { doing_list_id }
          allow(StartlingTrello).to receive(:api) { api }
          allow(StartlingTrello::Story).to receive(:new) { story }
        end

        it 'loads the Trello configuration' do
          expect(Startling::Configuration).to receive(:load_configuration)

          trello_start.execute
        end

        it 'fails if no doing list id is configured', :focus do
          allow(StartlingTrello).to receive(:doing_list_id) { nil }

          expect { trello_start.execute }.to raise_exception(SystemExit)
        end

        it 'finds card with id' do
          expect(api).to receive(:find_card).with(card_id)

          trello_start.execute
        end

        it 'finds list with doing list id' do
          expect(api).to receive(:find_list).with(doing_list_id)

          trello_start.execute
        end

        it 'moves the card to doing list' do
          expect(api).to receive(:move_card_to_list).with(card: card, list: list)

          trello_start.execute
        end

        it 'adds the member to the card' do
          expect(api).to receive(:add_member_to_card).with(card)

          trello_start.execute
        end

        it 'returns a story' do
          expect(StartlingTrello::Story).to receive(:new).with(card) { story }

          expect(trello_start.execute).to eq(story)
        end
      end

      describe '#get_card_url' do
        context 'when story id is defined in command line options' do
          let(:attrs) { { story_id: card_url } }

          it 'returns the card url' do
            expect(trello_start.get_card_url).to eq(card_url)
          end
        end

        context 'when there is at least one command line option' do
          let(:attrs) { { args: [card_url] } }

          it 'returns the card url' do
            expect(trello_start.get_card_url).to eq(card_url)
          end
        end

        context 'when card url is not specified' do
          let(:attrs) { { args: [] } }

          it 'prompts for card url' do
            allow_any_instance_of(TrelloStart).to receive(:ask) { card_url }

            expect(trello_start.get_card_url).to eq(card_url)
          end

          it 'returns error message if no card id is entered in prompt' do
            allow_any_instance_of(TrelloStart).to receive(:ask) { '' }

            expect { trello_start.get_card_url }.to raise_exception(SystemExit)
          end
        end

        describe "#get_card_id" do
          it 'extracts the trello id from short trello urls' do
            allow_any_instance_of(TrelloStart).to receive(:get_card_url) { card_url }

            expect(trello_start.get_card_id).to eq(card_id)
          end

          it 'extracts the trello id from long trello urls' do
            allow_any_instance_of(TrelloStart).to receive(:get_card_url) { 'https://trello.com/c/123abc/my-trello-card' }

            expect(trello_start.get_card_id).to eq(card_id)
          end

          it 'extracts the trello id from short trello urls with trailing forward slash' do
            allow_any_instance_of(TrelloStart).to receive(:get_card_url) { 'https://trello.com/c/123abc/' }

            expect(trello_start.get_card_id).to eq(card_id)
          end
        end
      end
    end
  end
end
