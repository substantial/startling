require 'spec_helper'
require 'teaching_channel_start/git_local'

module TeachingChannelStart
  describe GitLocal do
    subject { GitLocal.new }

    it "parses the repo name out of an https url" do
      url = 'https://github.com/TeachingChannel/teaching-channel-start.git'
      allow(subject).to receive(:remote_url) { url }

      expect(subject.repo_name).to eq('TeachingChannel/teaching-channel-start')
    end

    it "parses the repo name out of an ssh url" do
      url = 'git@github.com:TeachingChannel/teaching-channel-start.git'
      allow(subject).to receive(:remote_url) { url }

      expect(subject.repo_name).to eq('TeachingChannel/teaching-channel-start')
    end
  end
end
