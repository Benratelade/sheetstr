# frozen_string_literal: true

module Support
  module PageFragments
    module Timesheet
      def daily_breakdown
        breakdown_data = {}
        daily_breakdown_section = page.find("#daily-breakdown")
        daily_breakdown_section.find_all(".weekday-summary").each do |weekday_summary|
          weekday = weekday_summary.find(".weekday").text
          breakdown_data[weekday] = []

          weekday_summary.find_all(".line-item").each do |line_item|
            line_item_data = {
              "description" => line_item.find(".description").text,
              "total decimal hours" => line_item.find(".total-decimal-hours").text,
              "hourly rate" => line_item.find(".hourly-rate").text,
              "subtotal" => line_item.find(".subtotal").text,
            }
            breakdown_data[weekday] << line_item_data
          end
        end
        breakdown_data
      end
    end
  end
end
