# frozen_string_literal: true

require "rails_helper"

RSpec.describe LineItemFactory do
  describe ".create!" do
    it "creates a Line Item with the provided attributes and times built from the start_date" do
      timesheet = double("timesheet", id: "timesheet-id")

      expect(Utils::DateTimeBuilder).to(
        receive(:build_from_date_and_time).with(
          date: "the start date",
          time: "the start time",
        ),
      ).and_return("start date time")
      expect(Utils::DateTimeBuilder).to(
        receive(:build_from_date_and_time).with(
          date: "the start date",
          time: "the end time",
        ),
      ).and_return("end date time")

      expect(LineItem).to receive(:create!).with(
        {
          "timesheet_id" => "timesheet-id",
          "description" => "description",
          "start_time" => "start date time",
          "end_time" => "end date time",
          "hourly_rate" => "hourly rate",
        },
      )

      LineItemFactory.create!(
        timesheet: timesheet,
        attributes: {
          "description" => "description",
          "start_date" => "the start date",
          "start_time" => "the start time",
          "end_time" => "the end time",
          "hourly_rate" => "hourly rate",
        },
      )
    end
  end
end
