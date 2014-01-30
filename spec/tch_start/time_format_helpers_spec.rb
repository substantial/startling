require 'spec_helper'

describe TimeFormatHelpers, "#format_time" do
  include TimeFormatHelpers

  let(:minute) { 60 }
  let(:hour) { 60 * minute }
  let(:day) { 24 * hour }

  it "rounds down to hour" do
   format_time(1 * minute).should == 'less than an hour'
  end

  it "rounds down to the nearest hour" do
    time = (1 * hour) + (45 * minute)
    format_time(time).should == '1 hours'
  end

  it "includes days and hours" do
    time = (2 * day) + (4 * hour)
    format_time(time).should == '2 days and 4 hours'
  end
end
