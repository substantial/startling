require 'spec_helper'
require 'teaching_channel_start/pivotal_tracker/api'

module TeachingChannelStart
  module PivotalTracker
    describe Api do
      let(:api_token) { ENV.fetch 'TEST_PIVOTAL_TRACKER_API_TOKEN' }
      let(:api) { Api.new(api_token: api_token) }

      specify "#user_id should return the id of the current user",
        vcr: { cassette_name: "pivotal_tracker_api_user_id" } do
        api.user_id.should == 1240260
      end

      specify ".api_token should return the api_token of the user",
        vcr: { cassette_name: "pivotal_tracker_api_api_token" } do
        token = Api.api_token_for_user "aaron+tchtesting@substantial.com", "asdfasdf"
        token.should == api_token
      end

      # Uses https://www.pivotaltracker.com/story/show/65069954
      #
      # Preconditions:
      # Name should match tested name.
      specify "#story should return story details",
        vcr: { cassette_name: "pivotal_tracker_api_story" } do
        story = api.story(65069954)
        story["name"].should == "TEST: pivotal_tracker_api_story"
      end

      # Uses https://www.pivotaltracker.com/story/show/65072638
      #
      # Preconditions:
      # Story should not have an estimate
      specify "#update_story should update the story",
        vcr: { cassette_name: "pivotal_tracker_api_update_story" } do
        story_id = 65072638
        story = api.story(story_id)
        story["estimate"].should be_nil

        api.update_story story_id, estimate: 8

        story = api.story(story_id)
        story["estimate"].should == 8
      end
    end
  end
end
