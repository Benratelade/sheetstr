# frozen_string_literal: true

module LineItemRepository
  def self.update!(line_item:, attributes:)
    start_date = attributes.delete("start_date")

    line_item.update!(
      attributes.merge(
        {
          "start_time" => Utils::DateTimeBuilder.build_from_date_and_time(
            date: start_date,
            time: attributes["start_time"],
            timezone_identifier: "UTC",
          ),
          "end_time" => Utils::DateTimeBuilder.build_from_date_and_time(
            date: start_date,
            time: attributes["end_time"],
            timezone_identifier: "UTC",
          ),
        },
      ),
    )
  end
end
