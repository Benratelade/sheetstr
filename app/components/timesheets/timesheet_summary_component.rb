# frozen_string_literal: true

module Timesheets
  class TimesheetSummaryComponent < ViewComponent::Base
    def initialize(timesheet:)
      super
      @timesheet = timesheet
    end
  end
end
