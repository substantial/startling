require 'spec_helper'

require 'startling/commands/create_branch'

describe Startling::Commands::CreateBranch do
  let(:git) { double('GitLocal') }
  let(:attrs) { { args: [], git: git } }
  let(:create_branch) { Startling::Commands::CreateBranch.new(attrs) }

  describe '#execute' do
    let(:branch_name) { 'my-branch' }
    let(:attrs) { { args: [1, branch_name], git: git } }

    before do
      allow(create_branch).to receive(:valid_branch_name?) { true }
      allow(git).to receive(:current_branch) { 'current-branch' }
      allow(create_branch).to receive(:create_branch)
    end

    it 'returns an error if the branch name is invalid' do
      allow(create_branch).to receive(:valid_branch_name?) { false }

      expect { create_branch.execute }.to raise_exception(SystemExit)
    end

    it 'creates the branch if it is not the current branch' do
      allow(git).to receive(:current_branch) { 'current-branch' }

      expect(create_branch).to receive(:create_branch)
      create_branch.execute
    end

    it 'does not create the branch if it is the current branch' do
      allow(git).to receive(:current_branch) { branch_name }

      expect(create_branch).not_to receive(:create_branch)
      create_branch.execute
    end

    it 'returns the branch name' do
      expect(create_branch.execute).to eq(branch_name)
    end
  end

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
        allow_any_instance_of(Startling::Commands::CreateBranch).to receive(:ask) { 'entered branch' }

        expect(subject).to eq('entered-branch')
      end

      it 'returns the current branch when no branch is entered through the prompt' do
        allow_any_instance_of(Startling::Commands::CreateBranch).to receive(:ask) { '' }
        allow(git).to receive(:current_branch) { 'current-branch' }

        expect(subject).to eq('current-branch')
      end
    end
  end

  describe '#valid_branch_name?' do
    let(:branch_name) { 'validate-me' }
    let(:attrs) { { args: [1, branch_name] } }

    subject { create_branch.valid_branch_name? }

    before do
      allow(create_branch).to receive(:default_branch) { 'master' }
      allow(Startling).to receive(:validate_branch_name) { nil }
    end

    it 'succeeds if branch passes validation' do
      expect(subject).to be_truthy
    end

    it 'fails if the branch is the default branch' do
      allow(create_branch).to receive(:default_branch) { branch_name }

      expect(subject).to be_falsey
    end

    it 'fails if the custom validation Proc fails' do
      allow(Startling).to receive(:validate_branch_name) { -> (branch_name) { /feature\/.*/ =~ branch_name } }

      expect(subject).to be_falsey
    end
  end
end
