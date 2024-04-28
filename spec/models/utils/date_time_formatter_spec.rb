# frozen_string_literal: true

require "rails_helper"

RSpec.describe Utils::DateTimeFormatter do
  describe "#format_date" do
    it "returns an empty string when given an empty date" do
      expect(Utils::DateTimeFormatter.format_date(nil)).to eq("")
    end

    it "returns a Date to the format of DD Mon YYYY" do
      date = Date.parse("24 Jan 2022")
      expect(Utils::DateTimeFormatter.format_date(date)).to eq("Monday, 24 Jan 2022")
    end
  end

  describe "#format_date_in_timezone" do
    it "formats the date in the given timezone" do
      expect(
        Utils::DateTimeFormatter.format_date_in_timezone(
          date: Time.iso8601("2022-01-31T08:00:00+11:00"),
          timezone_identifier: "Sydney",
        ),
      ).to eq("Monday, 31 January 2022")

      expect(
        Utils::DateTimeFormatter.format_date_in_timezone(
          date: Time.iso8601("2022-01-31T08:00:00+10:00"),
          timezone_identifier: "UTC",
        ),
      ).to eq("Sunday, 30 January 2022")
    end
  end
end
