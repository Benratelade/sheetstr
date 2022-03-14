class Timesheet < ApplicationRecord
  has_many :line_items, class_name: "TimesheetLineItem"
  accepts_nested_attributes_for :line_items, reject_if: proc { |attributes| attributes['start_time'].blank? || attributes['end_time'].blank? }

  def total_hours_worked
    (line_items || []).sum(&:total_decimal_hours)
  end

  def hours_breakdown
    breakdown = {
      hours: 0,
      minutes: 0,
    }

    (line_items || []).each do |line_item|
      breakdown[:minutes] += line_item.hours_breakdown[:minutes]
      breakdown[:hours] += line_item.hours_breakdown[:hours]
    end

    if breakdown[:minutes] >= 60
      breakdown[:hours] += (breakdown[:minutes]) / 60
      breakdown[:minutes] = breakdown[:minutes] % 60
    end

    breakdown
  end
end