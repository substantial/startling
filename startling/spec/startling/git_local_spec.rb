require 'spec_helper'
require 'startling/git_local'

module Startling
  describe GitLocal do
    subject { GitLocal.new }

    it "parses the repo name out of an https url" do
      url = 'https://github.com/TeachingChannel/startling.git'
      allow(subject).to receive(:remote_url) { url }

      expect(subject.repo_name).to eq('TeachingChannel/startling')
    end

    it "parses the repo name out of an ssh url" do
      url = 'git@github.com:TeachingChannel/startling.git'
      allow(subject).to receive(:remote_url) { url }

      expect(subject.repo_name).to eq('TeachingChannel/startling')
    end
  end
end
