require 'spec_helper'
require 'startling'

module Startling
  describe ".configure" do
    before do
      Startling.configure do |config|
        config.cache_dir = "value"
      end
    end

    it "sets the configuration attributes" do
      expect(Startling.cache_dir).to eql("value")
    end
  end
end
