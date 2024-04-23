# frozen_string_literal: true

module Support
  module PageFragments
    module Timesheet
      def delete
        click_link("Delete")
      end

      def view(timesheet)
        page.find("[href*=\"#{timesheet.id}\"]", text: "View").click
      end

      def edit_line_item(line_item)
        page.find("[href*=\"#{line_item.id}\"]", text: "Edit").click
      end

      def summary
        Support::PageFragments::DescriptionList.new(page.find("#summary-section dl")).summary
      end

      def daily_breakdown
        breakdown_data = {}
        daily_breakdown_section = page.find("#daily-breakdown")
        daily_breakdown_section.find_all(".weekday-summary").each do |weekday_summary|
          build_weekday_summary(breakdown_data, weekday_summary)
        end
        breakdown_data
      end

      def items_summary
        summary_data = []
        items_summary_section = page.find("#items-summary")
        items_summary_section.find_all(".item-summary").each do |item_summary|
          build_item_summary(summary_data, item_summary)
        end
        summary_data
      end

      private

      def build_weekday_summary(hash, weekday_summary_section)
        weekday = weekday_summary_section.find(".weekday").text
        hash[weekday] ||= []

        weekday_summary_section.find_all(".line-item").each do |line_item|
          hash[weekday] << {
            "description" => line_item.find(".description").text,
            "date" => line_item.find(".date").text,
            "total decimal hours" => line_item.find(".total-decimal-hours").text,
            "hourly rate" => line_item.find(".hourly-rate").text,
            "subtotal" => line_item.find(".subtotal").text,
          }
        end
      end

      def build_item_summary(array, item_summary_section)
        array << {
          "description" => item_summary_section.find(".description").text,
          "total decimal hours" => item_summary_section.find(".total-decimal-hours").text,
          "hourly rate" => item_summary_section.find(".hourly-rate").text,
          "subtotal" => item_summary_section.find(".subtotal").text,
        }
      end
    end
  end
end
