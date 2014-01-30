module TeachingChannelStart
  class Cache
    attr_reader :cache_dir

    def initialize(cache_dir)
      @cache_dir = cache_dir
    end

    def fetch(path, &block)
      path = File.join(cache_dir, path)
      if File.exists? path
        File.read path
      else
        block.call.tap do |value|
          File.write path, value
        end
      end
    end
  end
end
