# frozen_string_literal: true

class TimesheetLineItem < ApplicationRecord
  belongs_to :timesheet

  def total_decimal_hours
    return 0 if start_time.blank? || end_time.blank?

    seconds = end_time - start_time
    seconds / 3600.to_d
  end

  def hours_breakdown # rubocop:todo Metrics/MethodLength
    breakdown = {
      hours: 0,
      minutes: 0,
    }

    return breakdown if start_time.blank? || end_time.blank?

    seconds = end_time - start_time
    minutes = seconds / 60
    hours = minutes / 60
    remaining_minutes = minutes % 60

    breakdown[:hours] = hours.to_i
    breakdown[:minutes] = remaining_minutes.to_i

    breakdown
  end

  def subtotal
    total_decimal_hours * (hourly_rate || 0)
  end
end
