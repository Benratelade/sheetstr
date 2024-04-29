# frozen_string_literal: true

require "rails_helper"

RSpec.describe Utils::DateTimeBuilder do
  describe ".build_from_date_and_time" do
    it "throws an error if there is no date" do
      expect do
        Utils::DateTimeBuilder.build_from_date_and_time(date: nil, time: "08:30")
      end.to raise_error("Missing date")
    end

    it "throws an error if there is no time" do
      expect do
        Utils::DateTimeBuilder.build_from_date_and_time(date: "2022-01-25", time: nil)
      end.to raise_error("Missing time")
    end

    it "builds a date from the date and time" do
      expect(
        Utils::DateTimeBuilder.build_from_date_and_time(date: "2022-01-25", time: "08:30"),
      ).to eq(Time.iso8601("2022-01-25T08:30:00Z"))
    end

    it "uses the timezone to create the date and time" do
      Time.use_zone("Sydney") do
        expect(
          Utils::DateTimeBuilder.build_from_date_and_time(date: "2022-01-25", time: "08:30"),
        ).to eq(Time.iso8601("2022-01-25T08:30:00+11:00"))
      end

      Time.use_zone("Paris") do
        expect(
          Utils::DateTimeBuilder.build_from_date_and_time(date: "2022-01-25", time: "08:30"),
        ).to eq(Time.iso8601("2022-01-25T08:30:00+01:00"))
      end
    end
  end
end
