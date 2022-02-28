class CreateTimesheets < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :timesheets, id: :uuid do |t|
      t.timestamps
    end
  end
end
