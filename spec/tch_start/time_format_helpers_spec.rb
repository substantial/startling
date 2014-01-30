require 'spec_helper'

describe TimeFormatHelpers, "#format_time" do
  include TimeFormatHelpers

  let(:minute) { 60 }

  it "rounds up to hours" do
   format_time(1 * minute).should == 'less than an hour'
  end
end
