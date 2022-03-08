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

  def create
    @timesheet = Timesheet.new(timesheet_params)
    if @timesheet.save!
      redirect_to @timesheet
    end
  end

  def show; end

  private
  
  def timesheet_params
    params.require(:timesheet).permit(
      :start_date, 
      :end_date, 
      line_items_attributes: [:description, :start_time, :end_time, :hourly_rate] 
    )
  end
end
