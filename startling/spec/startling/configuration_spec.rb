require 'spec_helper'
require 'startling'

module Startling
  describe Configuration do
    let(:configuration) { Configuration.new }
    let(:current_repo) { 'current' }
    let(:git_root) { `git rev-parse --show-toplevel`.strip }

    before do
      allow_any_instance_of(GitLocal).to receive(:repo_name) { current_repo }
    end

    describe "Default settings" do
      it "sets the default cache_dir to git root dir" do
        expect(configuration.cache_dir).to eql(git_root)
      end

      it "sets the default root_dir to git root dir" do
        expect(configuration.root_dir).to eql(git_root)
      end

      it "sets the default wip limit to WIP_LIMIT" do
        expect(configuration.wip_limit)
          .to eql(Configuration::DEFAULT_WIP_LIMIT)
      end

      it "sets the WIP labels to empty" do
        expect(configuration.wip_labels).to eql([])
      end

      it "sets the default repos to the current repo" do
        expect(configuration.repos).to eql([current_repo])
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

      # Pivotal
      it 'sets the default valid estimates' do
        expect(configuration.valid_estimates).to eql(Configuration::DEFAULT_VALID_ESTIMATES)
      end

      # Trello
      it 'sets the default developer public key' do
        expect(configuration.developer_public_key).to eql(nil)
      end

      it 'sets the doing list id' do
        expect(configuration.doing_list_id).to eql(nil)
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

    describe "#wip_labels" do
      it "can set the value" do
        configuration.wip_labels = ['WIP']
        expect(configuration.wip_labels).to eql(['WIP'])
      end
    end

    describe "#repos" do
      it "can set the value" do
        configuration.repos << "repo path"
        expect(configuration.repos).to eql([current_repo, "repo path"])
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

    # Pivotal
    describe "#valid_estimates" do
      it "can set the value" do
        configuration.valid_estimates = [1, 2]
        expect(configuration.valid_estimates).to eql([1, 2])
      end
    end

    # Trello
    describe '#developer_public_key' do
      it 'can set the value' do
        configuration.developer_public_key = '123abc'
        expect(configuration.developer_public_key).to eql('123abc')
      end
    end

    describe '#doing_list_id' do
      it 'can set the value' do
        configuration.doing_list_id = 'doing-list-id'
        expect(configuration.doing_list_id).to eql('doing-list-id')
      end
    end

    describe ".load_configuration" do
      let(:git) { double(GitLocal) }

      before do
        allow(Startling::GitLocal).to receive(:new) { git }
        allow(git).to receive(:project_root) { Dir.pwd }
      end

      context "when no configuration file exists" do
        it "uses default configuration" do
          expect(Configuration.load_configuration).to eql(nil)
        end
      end

      context "when a configuration file exists" do
        it "loads configuration from configuration file" do
          Startling::Configuration::DEFAULT_STARTLINGFILES.each do |config_file|
            File.open(config_file, "w")
            expect(Configuration.load_configuration).to eql(config_file)
            File.delete(config_file)
          end
        end
      end
    end
  end
end
