require 'spec_helper'

require 'teaching_channel_start/commands/base'

describe TeachingChannelStart::Commands::Base do
  it "should assigns key/values passed in as attributes" do
    base = TeachingChannelStart::Commands::Base.new(foo: 'bar', baz: 'qux')
    base.foo.should eq 'bar'
    base.baz.should eq 'qux'
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
      TeachingChannelStart::Commands::Base.stub(:new).and_return(base)

      TeachingChannelStart::Commands::Base.should_receive(:new).with(foo: 'bar')
      base.should_receive(:execute)

      subject
    end
  end
end
