require 'spec_helper'
require 'startling_trello/configuration'

module StartlingTrello
  describe Configuration do
    let(:configuration) { Configuration.new }

    describe 'Default settings' do
      it 'sets the default developer public key' do
        expect(configuration.developer_public_key).to eql(nil)
      end
    end

    describe '#developer_public_key' do
      it 'can set the value' do
        configuration.developer_public_key = '123abc'
        expect(configuration.developer_public_key).to eql('123abc')
      end
    end

    describe "#load_configuration" do
      let(:git) { double(Startling::GitLocal) }
      let(:config_file) { Configuration::DEFAULT_CONFIG_FILE }

      before do
        allow(Startling::GitLocal).to receive(:new) { git }
        allow(git).to receive(:project_root) { Dir.pwd }
      end

      after do
        delete_config_file(config_file)
      end

      context "when no configuration file exists" do
        it "uses default configuration" do
          expect(Configuration.load_configuration).to eql(nil)
        end
      end

      context "when a configuration file exists" do
        it "loads configuration from startling_trello_file.rb" do
          create_config_file(config_file)
          expect(Configuration.load_configuration).to eql(config_file)
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
