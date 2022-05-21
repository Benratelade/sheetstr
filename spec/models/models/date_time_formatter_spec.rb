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
end