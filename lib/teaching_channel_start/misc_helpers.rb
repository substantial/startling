module TeachingChannelStart
  module MiscHelpers
    def run(command)
      result = `#{command}`
      unless $?.success?
        exit 1
      end
      result
    end

    def escape_markdown(text)
      text.gsub('[', '\[').gsub(']', '\]')
    end
  end
end
