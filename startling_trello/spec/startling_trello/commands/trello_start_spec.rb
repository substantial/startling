require 'spec_helper'
require 'startling_trello/commands/trello_start'

module Startling
  module Commands
    describe TrelloStart do
      let(:card_id) { '123abc' }
      let(:attrs) { { story_id: card_id } }
      let(:trello_start) { TrelloStart.new(attrs) }

      describe '#execute' do
        let(:card) { double(:card) }
        let(:api) { double(:api, find_card: card) }

        before do
          allow(StartlingTrello).to receive(:api) { api }
        end

        it 'loads the Trello configuration' do
          expect(StartlingTrello::Configuration).to receive(:load_configuration)

          trello_start.execute
        end

        xit 'moves the card to doing list' do

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
