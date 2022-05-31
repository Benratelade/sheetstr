class RenameTimesheetLineItemsToLineItems < ActiveRecord::Migration[7.0]
  def change
    rename_table :timesheet_line_items, :line_items
  end
end
