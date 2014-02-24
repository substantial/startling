module TeachingChannelStart
  class Markdown
    def self.escape(text)
      text.gsub('[', '\[').gsub(']', '\]')
    end
  end
end
