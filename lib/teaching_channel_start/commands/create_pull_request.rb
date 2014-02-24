require_relative "base"

module TeachingChannelStart
  module Commands
    class CreatePullRequest < Base
      def execute
        url = open_pull_request
        amend_commit_with_pull_request(url)
      end

      def open_pull_request
        puts "Opening pull request..."
        Shell.run "git push -qu origin HEAD > /dev/null"

        pull_request = repo.open_pull_request title: pull_request_title,
          body: pull_request_body, branch: branch_name

        pull_request.url
      end

      def pull_request_path
        File.join(TeachingChannelStart.root_dir, pull_request_filename)
      end

      def pull_request_filename
        'BRANCH_PULL_REQUEST'
      end

      def pull_request_title
        "WIP: #{story.name}"
      end

      def amend_commit_with_pull_request(url)
        File.open(pull_request_path, "a") do |file|
          file.puts url
        end

        Shell.run "git add #{pull_request_path}"
        Shell.run "git commit -q --amend --reuse-message=HEAD"
        Shell.run "git push -qf origin HEAD"
      end

      def pull_request_body
        browsers = [
          "IE8 (minor issues are acceptable)",
          "IE9",
          "IE10",
          "IE11",
          "Firefox",
          "Safari",
          "Chrome",
        ]
        browser_checkboxes = browsers.map { |browser| "- [ ] Test in #{browser}" }.join("\n")
        <<BODY
        #{story.url}

        #{browser_checkboxes}
BODY
      end
    end
  end
end
