require 'spec_helper'

require 'startling/command'

describe Startling::Command do
  let(:command) { Startling::Command.new }

  describe '#execute' do
    before do
      allow(Startling::Commands::CheckForLocalMods).to receive(Startling::Command::RUN)

      allow(Startling)
        .to receive_message_chain(:hook_commands, :before_story_start) { [] }

      allow(Startling)
        .to receive_message_chain(:hook_commands, :after_story_start) { [] }

      allow(Startling)
        .to receive_message_chain(:hook_commands, :before_pull_request) { [] }

      allow(Startling)
        .to receive_message_chain(:hook_commands, :after_pull_request) { [] }

      allow(Startling).to receive(:story_handler) { nil }

      allow(Startling::Commands::CreatePullRequest).to receive(Startling::Command::RUN)
    end

    it 'should check for local modifications' do
      expect(Startling::Commands::CheckForLocalMods).to receive(Startling::Command::RUN)

      command.execute
    end

    it 'should run before story start commands' do
      allow(Startling)
        .to receive_message_chain(:hook_commands, :before_story_start) { [:create_branch] }

      expect(Startling::Commands::CreateBranch).to receive(Startling::Command::RUN)

      command.execute
    end

    it 'should start the story if a story handler is defined' do
      allow(Startling).to receive(:story_handler) { Startling::Commands::CreateBranch }

      expect(Startling::Commands::CreateBranch).to receive(Startling::Command::RUN)

      command.execute
    end

    it 'should run after story start commands' do
      allow(Startling)
        .to receive_message_chain(:hook_commands, :after_story_start) { [:create_branch] }

      expect(Startling::Commands::CreateBranch).to receive(Startling::Command::RUN)

      command.execute
    end

    it 'should run before pull request commands' do
      allow(Startling)
        .to receive_message_chain(:hook_commands, :before_pull_request) { [:create_branch] }

      expect(Startling::Commands::CreateBranch).to receive(Startling::Command::RUN)

      command.execute
    end

    it 'should create the pull request' do
      expect(Startling::Commands::CreatePullRequest).to receive(Startling::Command::RUN)

      command.execute
    end

    it 'should run after pull request commands' do
      allow(Startling)
        .to receive_message_chain(:hook_commands, :after_pull_request) { [:create_branch] }

      expect(Startling::Commands::CreateBranch).to receive(Startling::Command::RUN)

      command.execute
    end
  end
end
