require 'spec_helper'

require 'startling/commands/create_pull_request'

describe Startling::Commands::CreatePullRequest do
  let(:git) { double('GitLocal') }
  let(:attrs) { { git: git } }
  let(:create_pull_request) { Startling::Commands::CreatePullRequest.new(attrs) }

  describe '#open_pull_request' do
    let(:commit_message) { 'test' }
    let(:pull_request_handler) do
      double(:pull_request_handler,
        commit_message: commit_message,
        title: 'title',
        body: 'body'
      )
    end

    let(:repo) { double(:repo, open_pull_request: true) }

    before do
      allow(create_pull_request).to receive(:pull_request_handler) { pull_request_handler }
      allow(create_pull_request).to receive(:repo) { repo }

      allow(git).to receive(:current_branch_has_no_commits?) { false }
      allow(git).to receive(:create_empty_commit)
      allow(git).to receive(:push_origin_head)
    end

    it 'should create an empty commit when the branch has no commits' do
      allow(git).to receive(:current_branch_has_no_commits?) { true }

      expect(git).to receive(:create_empty_commit).with(commit_message)
      create_pull_request.open_pull_request
    end

    it 'should not create an empty commit when the branch has commits' do
      allow(git).to receive(:current_branch_has_no_commits?) { false }

      expect(git).not_to receive(:create_empty_commit)
      create_pull_request.open_pull_request
    end
  end
end
