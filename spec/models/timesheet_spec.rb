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
end
