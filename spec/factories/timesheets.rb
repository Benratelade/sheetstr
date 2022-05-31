# frozen_string_literal: true

FactoryBot.define do
  factory :timesheet do
    user { create(:user) }
    start_date { Date.parse("24 Jan 2022")}
    end_date { Date.parse("30 Jan 2022")}
  end
end
