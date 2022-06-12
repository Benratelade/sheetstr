# frozen_string_literal: true

class TimesheetsController < ApplicationController
  def index
    @timesheets = current_user.timesheets
  end

  def new
    @timesheet = Timesheet.new(
      start_date: Time.zone.today.beginning_of_week,
      end_date: Time.zone.today.end_of_week,
    )

    (@timesheet.start_date..@timesheet.end_date).each do |date|
      @timesheet.line_items << LineItem.new(start_time: date.beginning_of_day)
    end
  end

  def create
    @timesheet = Timesheet.new(timesheet_params.merge(user: current_user))
    if @timesheet.save
      redirect_to @timesheet
    else
      flash.now[:danger] = @timesheet.errors.full_messages.join(". ")
      render :new
    end
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
