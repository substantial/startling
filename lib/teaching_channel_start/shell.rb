module TeachingChannelStart
  class Shell
    def self.run(command)
      result = `#{command}`
      unless $?.success?
        exit 1
      end
      result
    end
  end
end
