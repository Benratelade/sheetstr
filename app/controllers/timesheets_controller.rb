class TimesheetsController < ActionController::Base
    def new
        @timesheet = Timesheet.new
    end
end
