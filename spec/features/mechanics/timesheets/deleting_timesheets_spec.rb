# frozen_string_literal: true

require "rails_helper"

describe "An existing user creates a timesheet from the index page", type: :feature do
  before do
    @otolose = create(:user)

    @timesheet_1 = create(
      :timesheet,
      user: @otolose,
      start_date: Date.parse("Jan 31 2022"),
      end_date: Date.parse("Feb 6 2022"),
    )

    create(
      :timesheet,
      user: @otolose,
      start_date: Date.parse("Feb 7 2022"),
      end_date: Date.parse("Feb 13 2022"),
    )

    create(
      :line_item,
      timesheet: @timesheet_1,
      start_time: Time.iso8601("2022-01-31T08:00:00+10:00"),
      end_time: Time.iso8601("2022-01-31T12:30:00+10:00"),
    )
  end

  scenario "Otolose deletes a timesheet" do
    When "a logged in user visits the list of her timesheets" do
      login_as(@otolose)
      visit(timesheets_path)
    end

    Then "a list of all her timesheets is shown" do
      wait_for { focus_on(Support::PageFragments::Table).table.data.count }.to eq(2)
    end

    When "she clicks to view one of her existing timesheets" do
      focus_on(Support::PageFragments::Table).table.rows.last.go_to("View")
    end

    And "she deletes the timesheet" do
      focus_on(Support::PageFragments::Timesheet).delete
    end

    Then "she gets redirected to the list of timesheets" do
      wait_for { current_path }.to eq("/timesheets")
    end

    And "there is only 1 timesheet left" do
      wait_for { focus_on(Support::PageFragments::Table).table.data.count }.to eq(1)
    end

    And "the associated line items have also been deleted" do
      wait_for { LineItem.count }.to eq(0)
    end
  end
end