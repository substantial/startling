require 'spec_helper'
require 'startling_trello/api'

module StartlingTrello
  describe Api do
    let(:client) { double(:client) }
    let(:api) do Api.new(
        developer_public_key: '123abc',
        member_token: '456def'
      )
    end

    before do
      allow(Trello::Client).to receive(:new) { client }
    end

    context '#find_card' do
      let(:card_id) { 'my-card' }

      it 'returns the card' do
        card = double(:card)
        expect(client).to receive(:find).with(:card, card_id) { card }

        expect(api.find_card(card_id)).to eq(card)
      end

      it 'returns an error message if the card could not be found' do
        allow(client).to receive(:find).and_raise(Trello::Error)

        expect { api.find_card(card_id) }.to raise_exception(SystemExit)
      end
    end
  end
end
