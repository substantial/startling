require 'spec_helper'

require 'teaching_channel_start/commands/base'

describe TeachingChannelStart::Commands::Base do
  it "should assigns key/values passed in as attributes" do
    base = TeachingChannelStart::Commands::Base.new(foo: 'bar', baz: 'qux')
    expect(base.foo).to eq 'bar'
    expect(base.baz).to eq 'qux'
  end

  describe '#execute' do
    subject { TeachingChannelStart::Commands::Base.new }
    it 'should throws NotImplementedError' do
      expect{ subject.execute }.to raise_error(NotImplementedError)
    end
  end

  describe '#run' do
    subject { TeachingChannelStart::Commands::Base.run(foo: 'bar')}

    it 'should assign attributes and call execute' do
      base =  double :base_command
      allow(TeachingChannelStart::Commands::Base).to receive(:new).and_return(base)

      expect(TeachingChannelStart::Commands::Base).to receive(:new).with(foo: 'bar')
      expect(base).to receive(:execute)

      subject
    end
  end
end
