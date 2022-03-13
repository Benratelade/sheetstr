require 'rails_helper'

RSpec.describe TimesheetLineItem, type: :model do
  describe "#total_decimal_hours" do
    it "returns 0 if start_time is nil" do 
      line_item = TimesheetLineItem.new(
        start_time: nil
      )

      expect(line_item.total_decimal_hours).to eq(0)
    end

    it "returns 0 if end_time is nil" do 
      line_item = TimesheetLineItem.new(
        end_time: nil
      )

      expect(line_item.total_decimal_hours).to eq(0)
    end

    it "returns the number of decimal hours between the start_time and end_time" do
      line_item = TimesheetLineItem.new(
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 17:30pm"),
      )

      expect(line_item.total_decimal_hours).to eq(9.5)
    end

    it "returns the number of decimal hours between the start_time and end_time, down to 2 decimals" do
      line_item = TimesheetLineItem.new(
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 14:33pm"),
      )

      expect(line_item.total_decimal_hours).to eq(6.55)
    end

    it "doesn't mind if start_time and end_time are on different dates" do
      line_item = TimesheetLineItem.new(
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Feb 01 2022 14:33pm"),
      )

      expect(line_item.total_decimal_hours).to eq(30.55)
    end
  end

  describe "#hours_breakdown" do
    it "returns a hash with 0 hours and 0 minutes when there is no start_time" do
      line_item = TimesheetLineItem.new(
        start_time: nil
      )

      expect(line_item.hours_breakdown).to eq({
        hours: 0, 
        minutes: 0, 
      })
    end

    it "returns a hash with 0 hours and 0 minutes when there is no end_time" do
      line_item = TimesheetLineItem.new(
        end_time: nil
      )

      expect(line_item.hours_breakdown).to eq({
        hours: 0, 
        minutes: 0, 
      })
    end

    it "returns the number of hours and minutes between the start_time and end_time in a hash" do
      line_item = TimesheetLineItem.new(
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 17:30pm"),
      )

      expect(line_item.hours_breakdown).to eq({
        hours: 9,
        minutes: 30,
      })
    end
  end
end
