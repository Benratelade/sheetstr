# frozen_string_literal: true

module Support
  module PageFragments
    module Timesheet
      def summary
        summary_section = page.find("section[data-test_id=summary-section]")

        summary = {
          "Duration (decimal)" => summary_section.find("#decimal-value").text,
          "Duration (in hours)" => summary_section.find("#hourly-value").text,
          "Total revenue" => summary_section.find("#total-revenue").text,
        }
      end

      def daily_breakdown
        breakdown_data = {}
        daily_breakdown_section = page.find("#daily-breakdown")
        daily_breakdown_section.find_all(".weekday-summary").each do |weekday_summary|
          build_weekday_summary(breakdown_data, weekday_summary)
        end
        breakdown_data
      end

      private

      def build_weekday_summary(hash, weekday_summary_section)
        weekday = weekday_summary_section.find(".weekday").text
        hash[weekday] ||= []

        weekday_summary_section.find_all(".line-item").each do |line_item|
          hash[weekday] << {
            "description" => line_item.find(".description").text,
            "total decimal hours" => line_item.find(".total-decimal-hours").text,
            "hourly rate" => line_item.find(".hourly-rate").text,
            "subtotal" => line_item.find(".subtotal").text,
          }
        end
      end
    end
  end
end
