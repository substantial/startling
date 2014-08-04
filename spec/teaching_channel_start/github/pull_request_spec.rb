require 'spec_helper'
require 'teaching_channel_start/github/pull_request'

module TeachingChannelStart
  module Github
    describe PullRequest, "#in_progress?" do

      it "should be true for WIP label" do
        pull_request = PullRequest.new(double(:attributes))
        allow(pull_request).to receive(:label_names) { ["WIP"] }

        expect(pull_request.in_progress?).to be_truthy
      end

      it "should be true for REVIEW label" do
        pull_request = PullRequest.new(double(:attributes))
        allow(pull_request).to receive(:label_names) { ["REVIEW"] }

        expect(pull_request.in_progress?).to be_truthy
      end

     it "should be false if for other labels" do
        pull_request = PullRequest.new(double(:attributes))
        allow(pull_request).to receive(:label_names) { ["some other thing", "bug"] }

        expect(pull_request.in_progress?).to be_falsey
     end

     it "should be false if no labels" do
        pull_request = PullRequest.new(double(:attributes))
        allow(pull_request).to receive(:label_names) { [] }

        expect(pull_request.in_progress?).to be_falsey
     end
    end
  end
end
