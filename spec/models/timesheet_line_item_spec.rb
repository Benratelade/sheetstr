require 'rails_helper'

RSpec.describe TimesheetLineItem, type: :model do
  describe "#total_decimal_hours" do
    it "returns 0 if start_time is nil" do 
      line_item = TimesheetLineItem.new(
        start_time: nil
      )

      expect(line_item.total_hours_worked).to eq(0)
    end

    it "returns 0 if end_time is nil" do 
      line_item = TimesheetLineItem.new(
        end_time: nil
      )

      expect(line_item.total_hours_worked).to eq(0)
    end

    it "returns the number of decimal hours between the start_time and end_time" do
      line_item = TimesheetLineItem.new(
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 17:30pm"),
      )

      expect(line_item.total_hours_worked).to eq(9.5)
    end

    it "returns the number of decimal hours between the start_time and end_time, down to 2 decimals" do
      line_item = TimesheetLineItem.new(
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 14:33pm"),
      )

      expect(line_item.total_hours_worked).to eq(6.55)
    end

    it "doesn't mind if start_time and end_time are on different dates" do
      line_item = TimesheetLineItem.new(
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Feb 01 2022 14:33pm"),
      )

      expect(line_item.total_hours_worked).to eq(30.55)
    end
  end
end
