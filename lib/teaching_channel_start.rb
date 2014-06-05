require_relative 'teaching_channel_start/command'

module TeachingChannelStart
  VALID_ESTIMATES = [0, 1, 2, 4, 8, 16, 32, 64, 128]
  WIP_LIMIT = 5
  REPOS = %w[
    TeachingChannel/teaching-channel
    TeachingChannel/teaching-channel-blog
    TeachingChannel/teaching-channel-chef
    TeachingChannel/teaching-channel-start
    TeachingChannel/teaching-channel-smoke
    TeachingChannel/flowdock_notify
  ]

  class << self
    attr_writer :cache_dir, :root_dir
  end

  def self.cache_dir
    @cache_dir or raise "set cache_dir="
  end

  def self.root_dir
    @root_dir or raise "set root_dir="
  end

  def self.cache
    @cache ||= Cache.new(cache_dir)
  end
end
