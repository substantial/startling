require 'config/startling_config'

module Startling
  class Configuration
    VALID_ESTIMATES = [1, 2, 4, 8, 16, 32, 64, 128]
    WIP_LIMIT = 4
#    REPOS = %w[
#      TeachingChannel/teaching-channel
#      TeachingChannel/teaching-channel-blog
#      TeachingChannel/teaching-channel-chef
#      TeachingChannel/teaching-channel-start
#      TeachingChannel/teaching-channel-smoke
#      TeachingChannel/flowdock_notify
#    ]

    attr_accessor :cache_dir, :root_dir, :valid_estimates, :wip_limit, :repos

    def initialize
      @cache_dir = Dir.pwd
      @root_dir = Dir.pwd
      @valid_estimates = VALID_ESTIMATES
      @wip_limit = WIP_LIMIT
      @repos = []
    end
  end
end
