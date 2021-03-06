# frozen_string_literal: true

module Timesheets
  class LineItemsController < ApplicationController
    def new
      @timesheet = current_user.timesheets.find(params[:timesheet_id])
      @line_item = LineItem.new(timesheet_id: @timesheet.id)
    end

    def create
      @timesheet = current_user.timesheets.find(params[:timesheet_id])
      @line_item = @timesheet.line_items.new(line_item_params)

      if @line_item.save
        redirect_to timesheet_path(@timesheet.id)
      else
        render :new
      end
    end

    def edit
      @timesheet = current_user.timesheets.find(params[:timesheet_id])
      @line_item = @timesheet.line_items.find(params[:id])
    end

    def update
      @timesheet = current_user.timesheets.find(params[:timesheet_id])
      @line_item = @timesheet.line_items.find(params[:id])
      return unless @line_item.update(line_item_params)

      flash[:notice] = "Line item was updated"
      redirect_to timesheet_path(@timesheet.id)
    end

    private

    def line_item_params
      params.require(:line_item).permit(
        :timesheet_id,
        :weekday,
        :description,
        :start_time,
        :end_time,
        :hourly_rate,
      ).to_h
    end
  end
end
