# frozen_string_literal: true

module LineItemFactory
  def self.create!(timesheet:, attributes:)
    start_date = attributes.delete("start_date")

    LineItem.create!(
      attributes.merge(
        {
          "timesheet_id" => timesheet.id,
          "start_time" => Utils::DateTimeBuilder.build_from_date_and_time(
            date: start_date,
            time: attributes["start_time"],
          ),
          "end_time" => Utils::DateTimeBuilder.build_from_date_and_time(
            date: start_date,
            time: attributes["end_time"],
          ),
        },
      ),
    )
  end
end
