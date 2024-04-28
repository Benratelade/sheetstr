# frozen_string_literal: true

Timesheet.all.each do |timesheet|
  start_date = timesheet.start_date

  timesheet.line_items.each do |line_item|
    line_item.update!(
      start_time: Utils::DateTimeBuilder.build_from_date_and_time(
        date: start_date.next_week(line_item.weekday.to_sym) - 7.days,
        time: line_item.start_time.strftime("%X"),
        timezone_identifier: "Sydney",
      ),
      end_time: Utils::DateTimeBuilder.build_from_date_and_time(
        date: start_date.next_week(line_item.weekday.to_sym) - 7.days,,
        time: line_item.end_time.strftime("%X"),
        timezone_identifier: "Sydney",
      ),
    )
  end
end

LineItem.all.each do |line_item|
  weekday = line_item.weekday
  calculated_weekday = Utils::DateTimeBuilder.build_from_date_and_time(
      date: line_item.timesheet.start_date.next_week(line_item.weekday.to_sym) - 7.days,
      time: line_item.start_time.strftime("%X"),
      timezone_identifier: "Sydney",
    ).strftime("%A").downcase

    ap(line_item: line_item.id, weekday: weekday, calculated_weekday: calculated_weekday) unless weekday == calculated_weekday
end
