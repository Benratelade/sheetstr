class TimesheetsController < ActionController::Base
    def new
        @timesheet = Timesheet.new(
            start_date: Date.today.beginning_of_week,
            end_date: Date.today.end_of_week,
        )

        (@timesheet.start_date..@timesheet.end_date).each do |date|
            @timesheet.line_items << TimesheetLineItem.new
        end
    end
end
