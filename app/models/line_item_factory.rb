# frozen_string_literal: true

module LineItemFactory
  def self.create!(timesheet:, attributes:)
    start_date = attributes.delete("start_date")

    LineItem.create!(
      attributes.merge(
        {
          "timesheet_id" => timesheet.id,
          "start_time" => DateTime.parse("#{start_date} #{attributes['start_time']}"),
          "end_time" => DateTime.parse("#{start_date} #{attributes['end_time']}"),
        },
      ),
    )
  end
end
