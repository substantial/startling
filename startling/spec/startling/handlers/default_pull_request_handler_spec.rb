require 'spec_helper'
require 'startling/handlers/default_pull_request_handler'

describe Startling::Handlers::DefaultPullRequestHandler do
  let(:args) { { story: nil } }
  subject { Startling::Handlers::DefaultPullRequestHandler.new(args) }

  it 'returns the commit message for empty commit' do
    commit_message = 'Commit message'

    allow(Startling).to receive(:pull_request_commit_message) { commit_message }

    expect(subject.commit_message).to eq(commit_message)
  end

  context 'with story' do
    let(:story) {
      double(:story,
        pull_request_title: 'Story title',
        pull_request_body_text: 'Story url'
      )
    }
    let(:args) { { story: story } }

    it 'returns the story pull request title' do
      expect(subject.title).to eq(story.pull_request_title)
    end

    it 'returns the story pull request body' do
      expect(subject.body).to eq(story.pull_request_body_text)
    end
  end

  context 'without story' do
    it 'prompts for pull request title' do
      title = 'Entered title'

      allow_any_instance_of(Startling::Handlers::DefaultPullRequestHandler)
        .to receive(:ask) { title }

      expect(subject.title).to eq(title)
    end

    it 'returns the pull request body from configuration' do
      body = 'Configured body'

      allow(Startling).to receive(:pull_request_body) { body }

      expect(subject.body).to eq(body)
    end
  end
end
