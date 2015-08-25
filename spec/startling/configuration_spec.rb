require 'spec_helper'
require 'startling'

module Startling
  describe Configuration do
    describe "#cache_dir" do
      it "sets the default value to pwd" do
        expect(Configuration.new.cache_dir).to eql(Dir.pwd)
      end

      it "can set the value" do
        config = Configuration.new
        config.cache_dir = "new dir"
        expect(config.cache_dir).to eql("new dir")
      end
    end

    describe "#root_dir" do
      it "sets the default value to pwd" do
        expect(Configuration.new.root_dir).to eql(Dir.pwd)
      end

      it "can set the value" do
        config = Configuration.new
        config.root_dir = "new dir"
        expect(config.root_dir).to eql("new dir")
      end
    end

    describe "#valid_estimates" do
      it "sets the default value to VALID_ESTIMATES" do
        expect(Configuration.new.valid_estimates)
          .to eql(Configuration::VALID_ESTIMATES)
      end

      it "can set the value" do
        config = Configuration.new
        config.valid_estimates = [1]
        expect(config.valid_estimates).to eql([1])
      end
    end

    describe "#wip_limit" do
      it "sets the default value to WIP_LIMIT" do
        expect(Configuration.new.wip_limit)
          .to eql(Configuration::WIP_LIMIT)
      end

      it "can set the value" do
        config = Configuration.new
        config.wip_limit = 6
        expect(config.wip_limit).to eql(6)
      end
    end

    describe "#repos" do
      it "sets the default value to []" do
        expect(Configuration.new.repos).to eql([])
      end

      it "can set the value" do
        config = Configuration.new
        config.repos = "repo path"
        expect(config.repos).to eql("repo path")
      end
    end
  end
end
