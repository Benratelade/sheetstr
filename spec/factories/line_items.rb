# frozen_string_literal: true

FactoryBot.define do
  factory :line_item do
    timesheet { create(:timesheet) }
    hourly_rate { 0 }
    currency { "AUD" }
  end
end
