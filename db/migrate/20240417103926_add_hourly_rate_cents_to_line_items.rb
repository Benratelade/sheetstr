class AddHourlyRateCentsToLineItems < ActiveRecord::Migration[7.1]
  def change
    add_column :line_items, :hourly_rate_cents, :integer
    add_column :line_items, :currency, :string, default: "XXX"
  end
end
