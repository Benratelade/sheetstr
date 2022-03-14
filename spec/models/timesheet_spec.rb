require 'rails_helper'

RSpec.describe Timesheet, type: :model do
  describe "#total_hours_worked" do
    it "returns 0 if there are no line items" do 
      timesheet = Timesheet.new()
      allow(timesheet).to receive(:line_items).and_return(nil)

      expect(timesheet.total_hours_worked).to eq(0)
    end

    it "returns the sum of all hours worked in each line item" do 
      line_item_1 = double(
        "line_item_1", 
        id: "the id",
        start_time: double("a start time"),
        end_time: double("an end time"),
        total_decimal_hours: 9,
      )
      line_item_2 = double(
        "line_item_2", 
        id: "the id",
        start_time: double("a start time"),
        end_time: double("an end time"),
        total_decimal_hours: 3.75,
      )
      association = double("association")
      timesheet = Timesheet.new()
      allow(timesheet).to receive(:line_items).and_return([line_item_1, line_item_2])

      expect(timesheet.total_hours_worked).to eq(12.75)
    end
  end

  describe "#hours_breakdown" do
    it "returns a hash with 0 hours and 0 minutes when there are no line_items" do
      timesheet = Timesheet.new()
      allow(timesheet).to receive(:line_items).and_return(nil)

      expect(timesheet.hours_breakdown).to eq({
        hours: 0, 
        minutes: 0, 
      })
    end

    it "returns a hash with the sum of all hours and minutes on all line_items" do
      timesheet = Timesheet.new()
      line_item_1 = double(
        "line_item_1", 
        id: "the id",
        hours_breakdown: {
          hours: 7, 
          minutes: 35,
        },
      )
      line_item_2 = double(
        "line_item_2", 
        id: "the id",
        hours_breakdown: {
          hours: 7, 
          minutes: 35,
        },
      )
      allow(timesheet).to receive(:line_items).and_return([line_item_1, line_item_2])

      expect(timesheet.hours_breakdown).to eq(
        {
          hours: 15, 
          minutes: 10, 
        }
      )
    end

    # it "returns the number of hours and minutes between the start_time and end_time in a hash" do
    #   line_item = TimesheetLineItem.new(
    #     start_time: Time.zone.parse("Jan 31 2022 08:00am"),
    #     end_time: Time.zone.parse("Jan 31 2022 17:30pm"),
    #   )

    #   expect(line_item.hours_breakdown).to eq({
    #     hours: 9,
    #     minutes: 30,
    #   })
    # end
  end
end
