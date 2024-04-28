# frozen_string_literal: true

module Timesheets
  class DailyBreakdownComponent < ViewComponent::Base
    def initialize(timesheet:, timezone_identifier:)
      super
      @timesheet = timesheet
      @timezone_identifier = timezone_identifier
    end
  end
end
