require 'spec_helper'

describe StartlingTrello do
  describe '#api' do
    let(:developer_public_key) { '123abc' }
    let(:member_token) { '456def' }
    let(:api) { double(:api) }

    before do
      allow(Startling).to receive(:developer_public_key) { developer_public_key }
      allow(Startling)
        .to receive_message_chain(:cache, :fetch)
        .with('.trello_member_token')
        .and_return(member_token)
    end

    it 'fails if no developer public key is configured' do
      allow(Startling).to receive(:developer_public_key) { nil }

      expect(Trello).to receive(:open_public_key_url)

      expect { StartlingTrello.api }.to raise_exception(SystemExit)
    end

    it 'prompts for member token if no member token cached' do
      input_member_token = 'entered token'
      allow(Startling)
        .to receive_message_chain(:cache, :fetch)
        .with('.trello_member_token')
        .and_yield
        .and_return(input_member_token)

      allow($terminal).to receive(:ask)

      expect(Trello)
        .to receive(:open_authorization_url).with(key: developer_public_key)

      expect(StartlingTrello::Api)
        .to receive(:new)
        .with(
          developer_public_key: developer_public_key,
          member_token: input_member_token
        )
        .and_return(api)

      expect(StartlingTrello.api).to eq(api)
    end
  end
end
