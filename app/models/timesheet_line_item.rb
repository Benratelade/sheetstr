class TimesheetLineItem < ApplicationRecord
  belongs_to :timesheet

  def total_hours_worked
    return 0 if (start_time.blank? || end_time.blank?)

    seconds = end_time - start_time
    seconds / 3600 
  end
end