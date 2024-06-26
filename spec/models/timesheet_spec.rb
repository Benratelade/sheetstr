# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timesheet, type: :model do
  describe "#total_decimal_hours" do
    it "returns 0 if there are no line items" do
      timesheet = Timesheet.new
      allow(timesheet).to receive(:line_items).and_return(nil)

      expect(timesheet.total_decimal_hours).to eq(0)
    end

    it "returns the sum of all hours worked in each line item" do
      line_item_1 = double(
        "line_item_1",
        id: "the id",
        start_time: double("a start time"),
        end_time: double("an end time"),
        total_decimal_hours: 9.to_d,
      )
      line_item_2 = double(
        "line_item_2",
        id: "the id",
        start_time: double("a start time"),
        end_time: double("an end time"),
        total_decimal_hours: 3.75.to_d,
      )
      timesheet = Timesheet.new
      allow(timesheet).to receive(:line_items).and_return([line_item_1, line_item_2])

      expect(timesheet.total_decimal_hours).to eq(12.75)
      expect(timesheet.total_decimal_hours).to be_a(BigDecimal)
    end
  end

  describe "#hours_breakdown" do
    it "returns a hash with 0 hours and 0 minutes when there are no line_items" do
      timesheet = Timesheet.new
      allow(timesheet).to receive(:line_items).and_return(nil)

      expect(timesheet.hours_breakdown).to eq(
        {
          hours: 0,
          minutes: 0,
        },
      )
    end

    it "returns a hash with the sum of all hours and minutes on all line_items" do
      timesheet = Timesheet.new
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
        },
      )
    end
  end

  describe "#total_revenue" do
    it "Returns 0 if there are no line_items" do
      timesheet = Timesheet.new
      allow(timesheet).to receive(:line_items).and_return(nil)

      expect(timesheet.total_revenue).to eq(0)
    end

    it "Returns the sum of all line_items subtotals" do
      timesheet = Timesheet.new
      line_item_1 = double(
        "line_item_1",
        id: "the id",
        subtotal: 321.to_d,
      )
      line_item_2 = double(
        "line_item_2",
        id: "the id",
        subtotal: 223.to_d,
      )
      allow(timesheet).to receive(:line_items).and_return([line_item_1, line_item_2])

      expect(timesheet.total_revenue).to eq(544)
      expect(timesheet.total_revenue).to be_a(BigDecimal)
    end
  end

  describe "#daily_line_items" do
    before do
      @timesheet = Timesheet.new
      @line_items_association = double("line items association")
      allow(@timesheet).to receive(:line_items).and_return(@line_items_association)
      allow(@line_items_association).to receive(:order)
    end

    it "returns information about line_items ordered by start time for each weekday" do
      line_item_1 = double(
        "line_item_1",
        day_of_week: "tuesday",
        start_time: "second",
      )

      line_item_2 = double(
        "line_item_2",
        day_of_week: "monday",
        start_time: "first",
      )

      expect(@line_items_association).to receive(:order).with(:start_time).and_return([line_item_1, line_item_2])

      expect(@timesheet.daily_line_items).to eq(
        {
          "monday" => [line_item_2],
          "tuesday" => [line_item_1],
        },
      )
    end

    it "groups line items by weekday" do
      line_item_1 = double(
        "line_item_1",
        day_of_week: "tuesday",
      )

      line_item_2 = double(
        "line_item_2",
        day_of_week: "tuesday",
      )

      allow(@line_items_association).to receive(:order).and_return([line_item_1, line_item_2])

      expect(@timesheet.daily_line_items).to eq(
        {
          "tuesday" => [line_item_1, line_item_2],
        },
      )
    end
  end

  describe "#grouped_line_items" do
    before do
      @timesheet = Timesheet.new
    end

    it "returns a summary of all line items that share the same description AND hourly rate, sorted by description" do
      line_item_1 = double(
        "line_item_1",
        description: "a description",
        hourly_rate: "an hourly rate",
        total_decimal_hours: 13,
        subtotal: 123,
      )

      line_item_2 = double(
        "line_item_2",
        description: "c different description",
        hourly_rate: "an hourly rate",
        total_decimal_hours: 72,
        subtotal: 728,
      )

      line_item_3 = double(
        "line_item_3",
        description: "a description",
        hourly_rate: "an hourly rate",
        total_decimal_hours: 14,
        subtotal: 231,
      )

      line_item_4 = double(
        "line_item_4",
        description: "b description",
        hourly_rate: "another hourly rate",
        total_decimal_hours: 55,
        subtotal: 500,
      )

      line_items_association = double("line items association")
      expect(@timesheet).to receive(:line_items).and_return(line_items_association)
      expect(line_items_association).to receive(:order).with("lower(description)").and_return(
        [
          line_item_1,
          line_item_3,
          line_item_4,
          line_item_2,
        ],
      )

      expect(@timesheet.grouped_line_items).to eq(
        [
          {
            description: "a description",
            hourly_rate: "an hourly rate",
            total_decimal_hours: 27,
            subtotal: 354,
          }, {
            description: "b description",
            hourly_rate: "another hourly rate",
            total_decimal_hours: 55,
            subtotal: 500,
          }, {
            description: "c different description",
            hourly_rate: "an hourly rate",
            total_decimal_hours: 72,
            subtotal: 728,
          },
        ],
      )
    end
  end

  describe "validations" do
    before do
      @user = create(:user)
    end

    it "must have a start date and an end date" do
      timesheet = Timesheet.new(user: @user)

      expect(timesheet).to be_invalid
      expect(timesheet.errors.full_messages).to eq(
        [
          "Start date is required",
          "End date is required",
        ],
      )
    end

    it "must have a start date on a monday" do
      timesheet = Timesheet.new(
        user: @user,
        start_date: Date.parse("Jan 18 2022"),
        end_date: Date.parse("Jan 24 2022"),
      )

      expect(timesheet).to be_invalid
      expect(timesheet.errors.full_messages).to eq(
        [
          "Timesheets must start on a Monday",
        ],
      )
    end

    it "must have an end date exactly 6 days after the start date" do
      timesheet = Timesheet.new(
        user: @user,
        start_date: Date.parse("Jan 17 2022"),
        end_date: Date.parse("Jan 18 2022"),
      )
      expect(timesheet).to be_invalid
      expect(timesheet.errors.full_messages).to eq(
        [
          "Timesheets must be 7 days long",
        ],
      )
    end
  end
end
