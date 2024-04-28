class CreateUserConfiguration < ActiveRecord::Migration[7.1]
  def change
    create_table :user_configurations, id: :uuid do |t|
      t.references :user, null: false
      t.string :timezone_identifier, null: false

      t.timestamps
    end
  end
end
