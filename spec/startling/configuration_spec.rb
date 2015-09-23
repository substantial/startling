require 'spec_helper'
require 'startling'

module Startling
  describe Configuration do
    let(:configuration) { Configuration.new }

    describe "Default settings" do
      it "sets the default cache_dir to pwd" do
        expect(configuration.cache_dir).to eql(Dir.pwd)
      end

      it "sets the default root_dir to pwd" do
        expect(configuration.root_dir).to eql(Dir.pwd)
      end
      it "sets the default valid estimates to VALID_ESTIMATES" do
        expect(configuration.valid_estimates)
          .to eql(Configuration::DEFAULT_VALID_ESTIMATES)
      end
      it "sets the default wip limit to WIP_LIMIT" do
        expect(configuration.wip_limit)
          .to eql(Configuration::DEFAULT_WIP_LIMIT)
      end
      it "sets the default repos to empty" do
        expect(configuration.repos).to eql([])
      end

      it "sets the default pull request labels" do
        expect(configuration.pull_request_labels).to eql([])
      end

      it "sets the default pull request body" do
        expect(configuration.pull_request_body).to eql("")
      end

      it "sets the default pull request filename" do
        expect(configuration.pull_request_filename)
          .to eql(Configuration::DEFAULT_PULL_REQUEST_FILENAME)
      end
    end

    describe "#cache_dir" do
      it "can set the value" do
        configuration.cache_dir = "new dir"
        expect(configuration.cache_dir).to eql("new dir")
      end
    end

    describe "#root_dir" do
      it "can set the value" do
        configuration.root_dir = "new dir"
        expect(configuration.root_dir).to eql("new dir")
      end
    end

    describe "#valid_estimates" do
      it "can set the value" do
        configuration.valid_estimates = [1]
        expect(configuration.valid_estimates).to eql([1])
      end
    end

    describe "#wip_limit" do
      it "can set the value" do
        configuration.wip_limit = 6
        expect(configuration.wip_limit).to eql(6)
      end
    end

    describe "#repos" do
      it "can set the value" do
        configuration.repos << "repo path"
        expect(configuration.repos).to eql(["repo path"])
      end
    end

    describe "#pull_request_filename" do
      it "can set the value" do
        configuration.pull_request_filename = "filename"
        expect(configuration.pull_request_filename).to eql("filename")
      end
    end

    describe "#pull_request_body" do
      it "can set the value" do
        configuration.pull_request_body = "body"
        expect(configuration.pull_request_body).to eql("body")
      end
    end

    describe "#pull_request_labels" do
      it "can set the value" do
        configuration.pull_request_labels = ["WIP", "REVIEW"]
        expect(configuration.pull_request_labels).to eql(["WIP", "REVIEW"])
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
