class Timesheet < ApplicationRecord
  has_many :line_items, class_name: "TimesheetLineItem"
end