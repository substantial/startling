require 'spec_helper'
require 'startling'
require 'startling_pivotal/configuration'

module StartlingPivotal
  describe Configuration do
    let(:configuration) { Configuration.new }

    describe 'Default settings' do
      it 'sets the default valid estimates' do
        expect(configuration.valid_estimates).to eql(Configuration::DEFAULT_VALID_ESTIMATES)
      end
    end

    describe "#valid_estimates" do
      it "can set the value" do
        configuration.valid_estimates = [1, 2]
        expect(configuration.valid_estimates).to eql([1, 2])
      end
    end

    describe "#load_configuration" do
      let(:git) { double(Startling::GitLocal) }
      let(:config_file) { "startling_pivotal_file.rb" }

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
        it "loads configuration from startling_pivotal_file.rb" do
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
