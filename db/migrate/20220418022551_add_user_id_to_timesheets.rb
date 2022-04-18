class AddUserIdToTimesheets < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to :timesheets, :user, foreign_key: true
  end
end
