require 'spec_helper'
require 'startling_trello/api'

module StartlingTrello
  describe Api do
    let(:client) { double(:client) }
    let(:member_token) { '456def' }
    let(:api) do Api.new(
        developer_public_key: '123abc',
        member_token: member_token
      )
    end

    before do
      allow(Trello::Client).to receive(:new) { client }
    end

    describe '#find_card' do
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

    describe '#find_list' do
      let(:list_id) { 'my-list' }

      it 'returns the list' do
        list = double(:list)
        expect(client).to receive(:find).with(:list, list_id) { list }

        expect(api.find_list(list_id)).to eq(list)
      end

      it 'returns an error message if the list could not be found' do
        allow(client).to receive(:find).and_raise(Trello::Error)

        expect { api.find_list(list_id) }.to raise_exception(SystemExit)
      end
    end

    describe '#find_board' do
      let(:board_id) { 'my-board' }

      it 'returns the board' do
        board = double(:board)
        expect(client).to receive(:find).with(:board, board_id) { board }

        expect(api.find_board(board_id)).to eq(board)
      end

      it 'returns an error message if the board could not be found' do
        allow(client).to receive(:find).and_raise(Trello::Error)

        expect { api.find_list(board_id) }.to raise_exception(SystemExit)
      end
    end

    it 'moves a card to a list' do
      card = double(:card)
      list = double(:list)

      expect(card).to receive(:move_to_list).with(list)

      api.move_card_to_list(card: card, list: list)
    end

    it 'gets the member from the member token' do
      member_id = 'member-id'
      token = double(:token, member_id: member_id)
      member = double(:member)

      allow(client).to receive(:find).with(:token, member_token) { token }
      allow(client).to receive(:find).with(:member, member_id) { member }

      expect(api.get_member_from_token).to eq(member)
    end

    it 'adds the member to the card' do
      member = double(:member)
      allow(api).to receive(:get_member_from_token) { member }

      card = double(:card)
      expect(card).to receive(:add_member).with(member)

      api.add_member_to_card(card)
    end


    describe '#add_link_to_card' do
      let(:url) { 'https://github.com/substantial/startling/pull/3' }
      let(:attachment) {
        Trello::Attachment.new({
          'id'           => 'abcdef123456789123456789',
          'name'         => 'Pull Request',
          'url'          => 'https://github.com/substantial/startling/pull/3',
          'bytes'        => 0,
          'idMember'     => 'abcdef123456789123456781',
          'isUpload'     => false,
          'date'         => '2013-02-28T17:12:28.497Z',
          'previews'     => 'previews'
        })
      }

      it 'adds a url attachment to the card' do
        card = double(:card)
        allow(card).to receive(:attachments) { [] }
        expect(card).to receive(:add_attachment)

        api.add_link_to_card(card, url)
      end

      it 'does not add a link to the card if there already is one' do
        card = double(:card)
        allow(card).to receive(:attachments) { [ attachment ] }
        expect(card).not_to receive(:add_attachment)

        api.add_link_to_card(card, url)
      end
    end
  end
end
