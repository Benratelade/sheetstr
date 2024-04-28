# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserConfiguration, type: :model do
  describe ".setup_complete?" do
    it "returns true if a timezone_identifier is set and valid" do
      expect(UserConfiguration.new(timezone_identifier: "Sydney").setup_complete?).to be(true)
    end

    it "returns false if there is no timezone_identfier" do
      expect(UserConfiguration.new(timezone_identifier: "").setup_complete?).to be(false)
      expect(UserConfiguration.new(timezone_identifier: nil).setup_complete?).to be(false)
    end

    it "raises an error if the timezone_identifier is invalid" do
      expect do
        UserConfiguration.new(timezone_identifier: "not valid").setup_complete?
      end.to raise_error(TZInfo::InvalidTimezoneIdentifier)
    end
  end
end
