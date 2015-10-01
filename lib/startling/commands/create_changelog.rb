require_relative '../markdown'
require_relative '../shell'
require_relative "base"

module Startling
  module Commands
    class CreateChangelog < Base
      def execute
        update_changelog
      end

      def changelog_message
        "* **#{story.story_type.upcase}:** [#{Markdown.escape(story.name)}](#{story.url})"
      end

      def changelog_filename
        'BRANCH_CHANGES.md'
      end

      def changelog_path
        File.join(Startling.root_dir, changelog_filename)
      end

      def read_changelog
        if File.exists? changelog_path
          changelog_contents = File.read(changelog_path)
        end
      end

      def update_changelog
        changelog_contents = read_changelog || ''
        return if changelog_contents.include? story.name

        puts "Updating #{changelog_filename}..."

        entries = changelog_contents.lines.to_a
        entries << changelog_message
        new_contents = entries.uniq.sort {|a,b| a <=> b}.join("\n")

        File.write(changelog_path, "#{new_contents}\n")

        Shell.run "git add #{changelog_filename}"
        commit_msg = <<-MSG
Update BRANCH_CHANGES

        #{story.name}
        #{story.url}
        MSG
        Shell.run "git commit -qm #{commit_msg.shellescape}"
      end

      def pivotal_tracker
        @pivotal_tracker ||= PivotalTracker.new(PivotalTracker::Helper.new.api_token)
      end

      def story
        @story ||= pivotal_tracker.story(story_id)
      end

      def story_id
        @story_id ||= extract_story_id_from_url(args.fetch(0) { ask("Enter story id to start: ") })
      end

      def extract_story_id_from_url(raw_story_id)
        raw_story_id
          .split("/")
          .last
          .gsub(/\D/, '')
      end
    end
  end
end
