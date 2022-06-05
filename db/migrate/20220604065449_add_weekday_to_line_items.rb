class AddWeekdayToLineItems < ActiveRecord::Migration[7.0]
  create_enum :weekdays, ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
  change_table :line_items do |t|
    t.enum "weekday", null: true, enum_type: "weekdays"
  end
end
