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

      it "sets the default wip limit to WIP_LIMIT" do
        expect(configuration.wip_limit)
          .to eql(Configuration::DEFAULT_WIP_LIMIT)
      end

      it "sets the default repos to empty" do
        expect(configuration.repos).to eql([])
      end

      it "sets the default story handler to nil" do
        expect(configuration.story_handler).to eql(nil)
      end

      it "sets the default branch name validator to nil" do
        expect(configuration.validate_branch_name).to eql(nil)
      end

      it "sets the default pull request handler to nil" do
        expect(configuration.pull_request_handler).to eql(nil)
      end

      it "sets the default pull request body" do
        expect(configuration.pull_request_body)
          .to eql(Configuration::DEFAULT_BODY)
      end

      it "sets the default pull request commit message" do
        expect(configuration.pull_request_commit_message)
          .to eql(Configuration::DEFAULT_COMMIT_MESSAGE)
      end

      it "sets the default pull request labels" do
        expect(configuration.pull_request_labels).to eql([])
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

    describe "#story_handler" do
      it "can set the value" do
        configuration.story_handler = :pivotal_start
        expect(configuration.story_handler).to eql(:pivotal_start)
      end
    end

    describe "#validate_branch_name" do
      it "can set the value" do
        validate_branch_name = -> (branch_name) { /feature\/.*/ =~ branch_name }
        configuration.validate_branch_name = validate_branch_name
        expect(configuration.validate_branch_name).to eql(validate_branch_name)
      end
    end

    describe "#pull_request_handler" do
      it "can set the value" do
        configuration.pull_request_handler = :custom
        expect(configuration.pull_request_handler).to eql(:custom)
      end
    end

    describe "#pull_request_body" do
      it "can set the value" do
        configuration.pull_request_body = "Startling Body"
        expect(configuration.pull_request_body).to eql("Startling Body")
      end
    end

    describe "#pull_request_commit_message" do
      it "can set the value" do
        configuration.pull_request_commit_message = "The Commit"
        expect(configuration.pull_request_commit_message).to eql("The Commit")
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
