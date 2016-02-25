require 'spec_helper'
require 'startling_trello/commands/trello_start'

module Startling
  module Commands
    describe TrelloStart do
      let(:card_id) { '123abc' }
      let(:attrs) { { story_id: card_id } }
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
          expect(StartlingTrello::Configuration).to receive(:load_configuration)

          trello_start.execute
        end

        it 'fails if no doing list id is configured', :focus do
          allow(StartlingTrello).to receive(:doing_list_id) { nil }

          expect { trello_start.execute }.to raise_exception(SystemExit)
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

      describe '#get_card_id' do
        context 'when story id is defined in command line options' do
          let(:attrs) { { story_id: '123abc' } }

          it 'returns the card id' do
            expect(trello_start.get_card_id).to eq(card_id)
          end
        end

        context 'when there is at least one command line option' do
          let(:attrs) { { args: ['123abc'] } }

          it 'returns the card id' do
            expect(trello_start.get_card_id).to eq(card_id)
          end
        end

        context 'when card id is not specified' do
          let(:attrs) { { args: [] } }

          it 'prompts for card id' do
            allow_any_instance_of(TrelloStart).to receive(:ask) { card_id }

            expect(trello_start.get_card_id).to eq(card_id)
          end

          it 'returns error message if no card id is entered in prompt' do
            allow_any_instance_of(TrelloStart).to receive(:ask) { '' }

            expect { trello_start.get_card_id }.to raise_exception(SystemExit)
          end
        end
      end
    end
  end
end