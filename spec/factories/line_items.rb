# frozen_string_literal: true

FactoryBot.define do
  factory :line_item do
    timesheet { create(:timesheet) }
  end
end
