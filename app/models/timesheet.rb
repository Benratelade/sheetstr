class Timesheet < ApplicationRecord
  has_many :line_items, class_name: "TimesheetLineItem"
  accepts_nested_attributes_for :line_items, reject_if: proc { |attributes| attributes['start_time'].blank? || attributes['end_time'].blank? }

  def total_hours_worked
    (line_items || []).sum(&:total_decimal_hours)
  end
end