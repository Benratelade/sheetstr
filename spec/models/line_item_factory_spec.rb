# frozen_string_literal: true

require "rails_helper"

RSpec.describe LineItemFactory do
  describe ".create!" do
    it "creates a Line Item with the provided attributes and times built from the start_date" do
      timesheet = double("timesheet", id: "timesheet-id")
      expect(LineItem).to receive(:create!).with(
        {
          "timesheet_id" => "timesheet-id",
          "description" => "description",
          "start_time" => DateTime.iso8601("2022-01-25T08:30:00Z"),
          "end_time" => DateTime.iso8601("2022-01-25T12:50:00Z"),
          "hourly_rate" => "hourly rate",
        },
      )

      LineItemFactory.create!(
        timesheet: timesheet,
        attributes: {
          "description" => "description",
          "start_date" => "2022-01-25",
          "start_time" => "08:30",
          "end_time" => "12:50",
          "hourly_rate" => "hourly rate",
        },
      )
    end
  end
end
