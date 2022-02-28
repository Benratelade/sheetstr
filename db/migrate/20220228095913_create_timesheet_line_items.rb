class CreateTimesheetLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :timesheet_line_items, id: :uuid do |t|
      t.string  :description
      t.datetime :start_time
      t.datetime :end_time
      t.decimal :hourly_rate
      t.decimal :subtotal
      t.references :timesheet, type: :uuid, index: true
      t.timestamps
    end
  end
end
