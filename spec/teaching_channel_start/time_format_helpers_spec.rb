require 'spec_helper'
require 'teaching_channel_start/time_format_helpers'

module TeachingChannelStart
  describe TimeFormatHelpers, "#business_time_ago" do
    include TimeFormatHelpers
    let(:minute) { 60 }
    let(:hour) { 60 * minute }
    let(:day) { 24 * hour }

    before do
      now =  Time.parse("February 7th, 2014, 1:00 pm")
      allow(Time).to receive(:now) { now }
    end

    it "says 1 day ago if it was yesterday" do
      time = Time.now - 1 * day
      expect(business_time_ago(time)).to eq("1 day ago")
    end

    it "says number of days if it was more than a day ago" do
      time = Time.now - 3 * day
      expect(business_time_ago(time)).to eq("3 days ago")
    end

    it "says number of hours if it is more than 1 hour" do
      time = Time.now - 2 * hour - 20 * minute
      expect(business_time_ago(time)).to eq("2 hours ago")
    end

    it "says number of hours if it is 1 hour" do
      time = Time.now - 1 * hour - 20 * minute
      expect(business_time_ago(time)).to eq("1 hour ago")
    end

    it "says less than an hour if it was" do
      time = Time.now - 40 * minute
      expect(business_time_ago(time)).to eq("less than an hour ago")
    end
  end
end
