# frozen_string_literal: true

class Timesheet < ApplicationRecord
  has_many :line_items
  belongs_to :user
  accepts_nested_attributes_for :line_items, reject_if: proc { |attributes|
    attributes["start_time"].blank? || attributes["end_time"].blank?
  }
  validates :start_date, presence: { message: "is required" }
  validates :end_date, presence: { message: "is required" }
  validate :must_start_on_a_monday, :must_be_7_days_long

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

  def grouped_line_items
    results_hash = line_items.each_with_object({}) do |line_item, hash|
      signature = "#{line_item.description} - #{line_item.hourly_rate}"

      if hash[signature].present?
        hash[signature][:total_decimal_hours] += line_item.total_decimal_hours
        hash[signature][:subtotal] += line_item.subtotal
      else
        hash[signature] = build_item_summary(line_item)
      end
    end

    results_hash.values
  end

  def daily_line_items
    weekdays = {}
    line_items.each do |line_item|
      weekdays[line_item.weekday] ||= []
      weekdays[line_item.weekday] << line_item
    end

    weekdays
  end

  private

  def must_start_on_a_monday
    errors.add(:base, "Timesheets must start on a Monday") if start_date && !start_date.monday?
  end

  def must_be_7_days_long
    errors.add(:base, "Timesheets must be 7 days long") if start_date && end_date && end_date - start_date != 6
  end

  def build_item_summary(line_item)
    {
      description: line_item.description,
      hourly_rate: line_item.hourly_rate,
      total_decimal_hours: line_item.total_decimal_hours,
      subtotal: line_item.subtotal,
    }
  end
end
