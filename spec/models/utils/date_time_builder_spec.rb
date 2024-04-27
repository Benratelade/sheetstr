# frozen_string_literal: true

require "rails_helper"

RSpec.describe Utils::DateTimeBuilder do
  describe ".build_from_date_and_time" do
    it "throws an error if there is no date" do
      expect do
        Utils::DateTimeBuilder.build_from_date_and_time(date: nil, time: "08:30", timezone_identifier: "UTC")
      end.to raise_error("Missing date")
    end

    it "throws an error if there is no time" do
      expect do
        Utils::DateTimeBuilder.build_from_date_and_time(date: "2022-01-25", time: nil, timezone_identifier: "UTC")
      end.to raise_error("Missing time")
    end

    it "throws an error if there is no timezone identifier" do
      expect do
        Utils::DateTimeBuilder.build_from_date_and_time(date: "2022-01-25", time: "08:30", timezone_identifier: nil)
      end.to raise_error("Missing timezone identifier")
    end

    it "builds a date from the date, time and timezone" do
      expect(
        Utils::DateTimeBuilder.build_from_date_and_time(date: "2022-01-25", time: "08:30", timezone_identifier: "UTC"),
      ).to eq(Time.iso8601("2022-01-25T08:30:00Z"))

      expect(
        Utils::DateTimeBuilder.build_from_date_and_time(date: "2022-01-25", time: "08:30",
                                                        timezone_identifier: "Brisbane",),
      ).to eq(Time.iso8601("2022-01-25T08:30:00+10:00"))

      expect(
        Utils::DateTimeBuilder.build_from_date_and_time(date: "2022-01-26", time: "23:30",
                                                        timezone_identifier: "Sydney",),
      ).to eq(Time.iso8601("2022-01-26T23:30:00+11:00"))

      expect(
        Utils::DateTimeBuilder.build_from_date_and_time(date: "2022-08-23", time: "08:30",
                                                        timezone_identifier: "Sydney",),
      ).to eq(Time.iso8601("2022-08-23T08:30:00+10:00"))
    end
  end
end
