module Startling
  class Story
    def pull_request_title
      raise NotImplementedError
    end

    def pull_request_body_text
      raise NotImplementedError
    end
  end
end
