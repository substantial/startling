require 'spec_helper'

require 'startling/commands/base'

describe Startling::Commands::Base do
  it "should assigns key/values passed in as attributes" do
    base = Startling::Commands::Base.new(foo: 'bar', baz: 'qux')
    expect(base.foo).to eq 'bar'
    expect(base.baz).to eq 'qux'
  end

  describe '#execute' do
    subject { Startling::Commands::Base.new }
    it 'should throws NotImplementedError' do
      expect{ subject.execute }.to raise_error(NotImplementedError)
    end
  end

  describe '#run' do
    subject { Startling::Commands::Base.run(foo: 'bar')}

    it 'should assign attributes and call execute' do
      base =  double :base_command
      allow(Startling::Commands::Base).to receive(:new).and_return(base)

      expect(Startling::Commands::Base).to receive(:new).with(foo: 'bar')
      expect(base).to receive(:execute)

      subject
    end
  end
end
