module TeachingChannelStart
  module PivotalTracker
    class Story
      attr_reader :story_id, :token

      def initialize(story_id, api)
        @story_id = story_id
        @api = api
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

      def update(new_attrs)
        api.update_story story_id, new_attrs
      end

      def attrs
        @attrs ||= api.story story_id
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
