module TeachingChannelStart
  module SystemHelpers
    def run(command)
      result = `#{command}`
      unless $?.success?
        exit 1
      end
      result
    end
  end
end
