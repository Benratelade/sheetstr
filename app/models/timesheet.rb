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

  def hours_breakdown # rubocop:todo Metrics/AbcSize
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

  private

  def must_start_on_a_monday
    if start_date
      errors.add(:base, "Timesheets must start on a Monday") unless start_date.monday?
    end
  end
  
  def must_be_7_days_long
    if start_date && end_date
      errors.add(:base, "Timesheets must be 7 days long") unless (end_date - start_date == 6)
    end
  end
end
