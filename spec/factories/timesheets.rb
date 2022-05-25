# frozen_string_literal: true

FactoryBot.define do
  factory :timesheet do
    user { create(:user) } 
  end
end
