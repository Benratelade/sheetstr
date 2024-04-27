# frozen_string_literal: true

require "rails_helper"

RSpec.describe LineItemRepository do
  describe ".update!" do
    it "updates the provided line_item with the provided params" do
      line_item = double("line item")

      expect(Utils::DateTimeBuilder).to(
        receive(:build_from_date_and_time).with(
          date: "the start date",
          time: "the start time",
          timezone_identifier: "UTC",
        ),
      ).and_return("start date time")
      expect(Utils::DateTimeBuilder).to(
        receive(:build_from_date_and_time).with(
          date: "the start date",
          time: "the end time",
          timezone_identifier: "UTC",
        ),
      ).and_return("end date time")

      expect(line_item).to receive(:update!).with(
        {
          "hourly_rate" => "hourly rate",
          "description" => "description",
          "start_time" => "start date time",
          "end_time" => "end date time",
        },
      )

      LineItemRepository.update!(
        line_item: line_item,
        attributes: {
          "hourly_rate" => "hourly rate",
          "description" => "description",
          "start_date" => "the start date",
          "start_time" => "the start time",
          "end_time" => "the end time",
        },
      )
    end
  end
end
