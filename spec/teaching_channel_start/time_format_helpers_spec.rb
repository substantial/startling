require 'spec_helper'
require 'teaching_channel_start/time_format_helpers'

module TeachingChannelStart
  describe TimeFormatHelpers, "#time_from_now" do
    include TimeFormatHelpers
    let(:minute) { 60 }
    let(:hour) { 60 * minute }
    let(:day) { 24 * hour }

    it "rounds down to hour" do
      time = Time.now - (30 * minute)
      time_from_now(time).should == 'less than an hour ago'
    end

    it "rounds down to the nearest hour" do
      time = Time.now - (1 * hour)
      time_from_now(time).should == '1 hour ago'
    end

     it "includes days and hours" do
       time = Time.now - ((2 * day) + (4 * hour))
       time_from_now(time).should == '2 days 4 hours ago'
     end

     it "rounds down to the nearest day" do
       time = Time.now - ((1 * day) + (2 * minute))
       time_from_now(time).should == '1 day ago'
     end

     it "handles future times" do
       time = Time.now + ((1 * day) + (2 * minute))
       time_from_now(time).should == '1 day from now'
     end
  end
end
