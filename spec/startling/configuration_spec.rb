require 'spec_helper'
require 'startling'

module Startling
  describe Configuration do
    describe "Default settings" do
      it "sets the default cache_dir to pwd" do
        expect(Configuration.new.cache_dir).to eql(Dir.pwd)
      end
      it "sets the default root_dir to pwd" do
        expect(Configuration.new.root_dir).to eql(Dir.pwd)
      end
      it "sets the default valid estimates to VALID_ESTIMATES" do
        expect(Configuration.new.valid_estimates)
          .to eql(Configuration::VALID_ESTIMATES)
      end
      it "sets the default wip limit to WIP_LIMIT" do
        expect(Configuration.new.wip_limit)
          .to eql(Configuration::WIP_LIMIT)
      end
      it "sets the default repos to empty" do
        expect(Configuration.new.repos).to eql([])
      end
    end

    describe "#cache_dir" do
      it "can set the value" do
        config = Configuration.new
        config.cache_dir = "new dir"
        expect(config.cache_dir).to eql("new dir")
      end
    end

    describe "#root_dir" do
      it "can set the value" do
        config = Configuration.new
        config.root_dir = "new dir"
        expect(config.root_dir).to eql("new dir")
      end
    end

    describe "#valid_estimates" do
      it "can set the value" do
        config = Configuration.new
        config.valid_estimates = [1]
        expect(config.valid_estimates).to eql([1])
      end
    end

    describe "#wip_limit" do
      it "can set the value" do
        config = Configuration.new
        config.wip_limit = 6
        expect(config.wip_limit).to eql(6)
      end
    end

    describe "#repos" do
      it "can set the value" do
        config = Configuration.new
        config.repos = "repo path"
        expect(config.repos).to eql("repo path")
      end
    end

    describe ".load_configuration" do
      let(:git) { double(GitLocal) }
      let(:config_files) {
        {
          caps:  "Startlingfile.rb",
          lower: "startlingfile.rb"
        }
      }
      let(:caps_config_file) { "Startlingfile.rb" }
      let(:lower_config_file) { "startlingfile.rb" }

      before do
        allow(Startling::GitLocal).to receive(:new) { git }
        allow(git).to receive(:project_root) { Dir.pwd }
      end

      after do
        config_files.each do |_, v|
          delete_config_file(v)
        end
      end

      context "when no configuration file exists" do
        it "uses default configuration" do
          expect(Configuration.load_configuration).to eql(nil)
        end
      end

      context "when a configuration file exists" do
        it "loads configuration from Startlingfile.rb" do
          create_config_file(config_files[:caps])
          expect(Configuration.load_configuration).to eql(config_files[:caps])
        end

        it "loads configuration from startlingfile.rb" do
          create_config_file(config_files[:lower])
          expect(Configuration.load_configuration).to eql(config_files[:lower])
        end
      end
    end

    def create_config_file(config_file)
      File.open(config_file, "w")
    end

    def delete_config_file(config_file)
      File.delete(config_file) if File.exists? config_file
    end
  end
end
