# frozen_string_literal: true

class TimesheetsController < ActionController::Base
  def new
    @timesheet = Timesheet.new(
      start_date: Time.zone.today.beginning_of_week,
      end_date: Time.zone.today.end_of_week,
    )

    (@timesheet.start_date..@timesheet.end_date).each do |date|
      @timesheet.line_items << TimesheetLineItem.new(start_time: date.beginning_of_day)
    end
  end

  def create
    @timesheet = Timesheet.new(timesheet_params)
    redirect_to @timesheet if @timesheet.save!
  end

  def show
    @timesheet = Timesheet.find(params[:id])
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(
      :start_date,
      :end_date,
      line_items_attributes: %i[description start_time end_time hourly_rate],
    )
  end
end
