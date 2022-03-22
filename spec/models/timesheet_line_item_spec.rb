# frozen_string_literal: true

require "rails_helper"

RSpec.describe TimesheetLineItem, type: :model do
  describe "#total_decimal_hours" do
    it "returns 0 if start_time is nil" do
      line_item = TimesheetLineItem.new(
        start_time: nil,
      )

      expect(line_item.total_decimal_hours).to eq(0)
    end

    it "returns 0 if end_time is nil" do
      line_item = TimesheetLineItem.new(
        end_time: nil,
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

    it "returns the number of decimal hours between the start_time and end_time, as a BigDecimal" do
      line_item = TimesheetLineItem.new(
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 14:47pm"),
      )

      expect(line_item.total_decimal_hours).to be_a(BigDecimal)
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
        start_time: nil,
      )

      expect(line_item.hours_breakdown).to eq(
        {
          hours: 0,
          minutes: 0,
        },
      )
    end

    it "returns a hash with 0 hours and 0 minutes when there is no end_time" do
      line_item = TimesheetLineItem.new(
        end_time: nil,
      )

      expect(line_item.hours_breakdown).to eq(
        {
          hours: 0,
          minutes: 0,
        },
      )
    end

    it "returns the number of hours and minutes between the start_time and end_time in a hash" do
      line_item = TimesheetLineItem.new(
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 17:30pm"),
      )

      expect(line_item.hours_breakdown).to eq(
        {
          hours: 9,
          minutes: 30,
        },
      )
    end
  end

  describe "#subtotal" do
    it "returns 0 if the hourly rate is nil" do
      line_item = TimesheetLineItem.new(hourly_rate: nil)
      allow(line_item).to receive(:total_decimal_hours).and_return(10)

      expect(line_item.subtotal).to eq(0)
    end

    it "returns the product of hourly rate timed by the number of decimal hours" do
      line_item = TimesheetLineItem.new(hourly_rate: 25)
      allow(line_item).to receive(:total_decimal_hours).and_return(16.7)

      expect(line_item.subtotal).to eq(417.5)
      expect(line_item.subtotal).to be_a(BigDecimal)
    end
  end
end
