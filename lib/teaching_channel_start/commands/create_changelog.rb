require_relative '../misc_helpers'

module TeachingChannelStart
  module Commands
    class CreateChangelog
      include MiscHelpers

      attr_reader :story

      def initialize(options={})
        @story = options.fetch(:story)
      end

      def call
        update_changelog
      end

      def changelog_message
        "* **#{story.story_type.upcase}:** [#{escape_markdown(story.name)}](#{story.url})"
      end

      def changelog_filename
        'BRANCH_CHANGES.md'
      end

      def changelog_path
        File.join(TeachingChannelStart.root_dir, changelog_filename)
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

        run "git add #{changelog_filename}"
        commit_msg = <<-MSG
Update BRANCH_CHANGES

        #{story.name}
        #{story.url}
        MSG
        run "git commit -qm #{commit_msg.shellescape}"
      end
    end
  end
end
