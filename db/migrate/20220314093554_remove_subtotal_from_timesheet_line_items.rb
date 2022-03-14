class RemoveSubtotalFromTimesheetLineItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :timesheet_line_items, :subtotal
  end
end
