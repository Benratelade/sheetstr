# frozen_string_literal: true

class LineItem < ApplicationRecord
  belongs_to :timesheet

  monetize :hourly_rate_cents
  monetize :subtotal_cents

  enum weekday: {
    monday: "monday",
    tuesday: "tuesday",
    wednesday: "wednesday",
    thursday: "thursday",
    friday: "friday",
    saturday: "saturday",
    sunday: "sunday",
  }

  def total_decimal_hours
    return 0 if start_time.blank? || end_time.blank?

    seconds = end_time - start_time
    seconds / 3600.to_d
  end

  def hours_breakdown
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

  def subtotal_cents
    total_decimal_hours * (hourly_rate_cents || 0)
  end

  def available_dates
    dates = {}
    (timesheet.start_date..timesheet.start_date + 6.days).each do |date|
      dates[date.strftime("%A, %d %B %Y")] = date
    end

    dates
  end

  def day_of_week
    start_time.strftime("%A").downcase
  end
end
