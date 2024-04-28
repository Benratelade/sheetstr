# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "#setup_complete?" do
    it "returns true if the user configuration is fully configured" do
      user_configuration = double(
        "user settings",
        setup_complete?: true,
        is_a?: true,
        _write_attribute: nil,
        _has_attribute?: nil,
      )
      user = User.new(user_configuration: user_configuration)

      expect(user.setup_complete?).to be(true)
    end

    it "returns false if the user configuration is NOT fully configured" do
      user_configuration = double(
        "user settings",
        setup_complete?: false,
        is_a?: true,
        _write_attribute: nil,
        _has_attribute?: nil,
      )
      user = User.new(user_configuration: user_configuration)

      expect(user.setup_complete?).to be(false)
    end

    it "returns false if the user does not have a configuration" do
      user = User.new(user_configuration: nil)

      expect(user.setup_complete?).to be(false)
    end
  end

  describe "#timezone_identifier" do
    context "the user has no user_configuration" do
      it "returns UTC" do
        expect(User.new().timezone_identifier).to eq("UTC")
      end
    end

    context "the user has a user_configuration" do
      it "returns the timezone_identifier from the user_configuration" do
        user_configuration = double(
        "user settings",
        timezone_identifier: "Sydney",
        is_a?: true,
        _write_attribute: nil,
        _has_attribute?: nil,
      )

        expect(
          User.new(user_configuration: user_configuration).timezone_identifier
        ).to eq("Sydney")
      end
    end
  end
end
