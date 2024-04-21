# frozen_string_literal: true

module Timesheets
  class DailyBreakdownComponent < ViewComponent::Base
    def initialize(timesheet:)
      super
      @timesheet = timesheet
    end
  end
end