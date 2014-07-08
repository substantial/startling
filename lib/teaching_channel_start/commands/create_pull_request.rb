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

### Browser Testing

#{browser_checkboxes}

### CSS

- [ ] New CSS is added to style engine and follows [guidelines](https://github.com/TeachingChannel/teaching-channel/blob/master/GUIDELINES.md#cssstyle).
- [ ] New patterns contain no outside margin or padding.
- [ ] New patterns styles do not reference any other pattern classes.

### Migrations

- [ ] [Migrations are safe to run in zero downtime deploy.](https://github.com/TeachingChannel/teaching-channel/wiki/Migrations)
- [ ] LHM is used for large tables like users, activities, probably others.

### Security

- [ ] Features have appropriate authorization checks.

### Analytics

- [ ] Analytic classes ('a-') have been added.
BODY
      end
    end
  end
end
