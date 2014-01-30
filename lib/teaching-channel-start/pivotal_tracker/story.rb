module TeachingChannelStart
  module PivotalTracker
    class Story
      attr_reader :story_id, :token

      def initialize(story_id, token=PivotalTracker::Client.token)
        @story_id = story_id
        @token = token
      end

      def name ;        remove_prefix(attrs["name"]) ; end
      def story_type ;  attrs["story_type"] ; end
      def url ;         attrs["url"] ; end
      def estimate ;    attrs["estimate"] ; end
      def project_id ;  attrs["project_id"] ; end

      def estimated?
        return true if story_type != "feature"
        return false if estimate.nil?
        Integer(estimate) > 0
      end

      def get_url
        "https://www.pivotaltracker.com/services/v5/stories/#{story_id}"
      end

      def update_url
        "https://www.pivotaltracker.com/services/v5/projects/#{project_id}/stories/#{story_id}"
      end

      def update(new_attrs)
        body = new_attrs.to_json

        request do
          `curl -s -H "X-TrackerToken: #{token}" -H "Content-type: application/json" -d '#{body}' -X PUT "#{update_url}"`
        end
      end

      def attrs
        @attrs ||= request { `curl -s -H "X-TrackerToken: #{token}" -X GET #{get_url}` }
      end

      def request &block
        raw_response = block.call
        response = JSON.parse(raw_response)

        unless response.has_key?("name")
          raise raw_response
        end

        response
      end

      # Sometimes stories have a note in front of their title like
      # *[BLOCKED]*, this removes it.
      def remove_prefix(name)
        name.sub(/^(\*.*?\* *)+/, "").strip
      end
    end
  end
end
