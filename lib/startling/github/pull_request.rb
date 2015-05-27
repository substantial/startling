module Startling
  module Github
    class PullRequest
      attr_reader :attributes
      attr_accessor :labels

      def initialize(attributes, prefetch_data: true)
        @attributes = attributes
        prefetch_data if prefetch_data
      end

      def id
        attributes.number
      end

      def title
        attributes.title
      end

      def branch
        attributes.head.ref
      end

      def in_progress?
        label_names.any? { |label| label.match(/(WIP|REVIEW)/) }
      end

      def label_names
        labels.map(&:name)
      end

      def url
        attributes.rels[:html].href
      end

      def created_at
        attributes.created_at
      end

      def updated_at
        attributes.updated_at
      end

      def author
        @author ||= attributes.user.rels[:self].get.data.name
      end

      private
      def prefetch_data
        author
      end
    end
  end
end
