class AddStartDateAndEndDateToTimesheets < ActiveRecord::Migration[7.0]
  def change
    add_column :timesheets, :start_date, :date
    add_column :timesheets, :end_date, :date
  end
end
