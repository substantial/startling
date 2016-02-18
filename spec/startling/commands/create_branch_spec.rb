require 'spec_helper'

require 'startling/commands/create_branch'

describe Startling::Commands::CreateBranch do
  let(:git) { double('GitLocal') }
  let(:attrs) { { args: [], git: git } }
  let(:create_branch) { Startling::Commands::CreateBranch.new(attrs) }

  describe '#branch_name' do
    subject { create_branch.branch_name }

    context 'when branch command line option is set' do
      let(:attrs) { { args: [1, 'test everything'] } }

      it 'returns the command line option' do
        expect(subject).to eq('test-everything')
      end
    end

    context 'when branch command line option is not set' do
      let(:default_branch) { 'master' }

      before do
        allow(create_branch).to receive(:default_branch) { default_branch }
      end

      it 'returns the branch entered through the prompt' do
        allow($terminal).to receive(:ask) { 'entered branch' }

        expect(subject).to eq('entered-branch')
      end

      it 'returns the current branch when no branch is entered through prompt' do
        allow($terminal).to receive(:ask) { '' }
        allow(git).to receive(:current_branch) { 'current-branch' }

        expect(subject).to eq('current-branch')
      end

      it 'returns an error if the current branch is the default branch' do
        allow($terminal).to receive(:ask) { '' }
        allow(git).to receive(:current_branch) { default_branch }

        expect { create_branch.branch_name }.to raise_exception(SystemExit)
      end
    end
  end
end
