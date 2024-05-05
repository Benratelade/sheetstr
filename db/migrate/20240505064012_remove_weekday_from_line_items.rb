class RemoveWeekdayFromLineItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :line_items, :weekday
  end
end
