# frozen_string_literal: true

class Timesheet < ApplicationRecord
  has_many :line_items, class_name: "TimesheetLineItem"
  accepts_nested_attributes_for :line_items, reject_if: proc do |attributes|
    attributes["start_time"].blank? || attributes["end_time"].blank?
  end

  def total_decimal_hours
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

  def total_revenue
    (line_items || []).sum(&:subtotal)
  end
end
