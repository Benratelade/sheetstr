# frozen_string_literal: true

require "rails_helper"

describe "An existing user creates a timesheet from the index page", type: :feature do
  before do
    @otolose = create(:user)
    Timecop.freeze(Date.parse("Jan 30 2022"))
  end
  scenario "Otolose creates a timesheet and sees it in her list of timesheets" do
    When "Otolose is logged in and visits the list of her timesheets" do
      login_as(@otolose)
      visit(timesheets_path)
    end

    Then "she sees an empty list of timesheets" do
      table = focus_on(Support::PageFragments::Table).table("table#timesheets-table")
      wait_for { table.data }.to eq([])
    end

    When "she clicks on a link to create a new timesheet" do
      click_on("Create timesheet")
    end

    Then "she sees a form for a new timesheet" do
      wait_for { focus_on(Support::PageFragments::Form).form("form").labels }.to eq(
        [
          "Start date",
          "End date",
          "Description",
          "Start time",
          "End time",
          "Hourly rate",
          "Description",
          "Start time",
          "End time",
          "Hourly rate",
          "Description",
          "Start time",
          "End time",
          "Hourly rate",
          "Description",
          "Start time",
          "End time",
          "Hourly rate",
          "Description",
          "Start time",
          "End time",
          "Hourly rate",
          "Description",
          "Start time",
          "End time",
          "Hourly rate",
          "Description",
          "Start time",
          "End time",
          "Hourly rate"
        ],
      )
    end

    And "the start and end dates are prefilled for this calendar week" do
      wait_for { focus_on(Support::PageFragments::Form).form("form").value_for("Start date") }.to eq("2022-01-24")
      wait_for { focus_on(Support::PageFragments::Form).form("form").value_for("End date") }.to eq("2022-01-30")
    end

    When "she fills out the form and submits it" do
      pending
    end

    Then "a summary of the new timesheet is displayed" do
      pending
    end

    When "she goes to the list of her timesheets" do
      pending
    end

    Then "the new timesheet is displayed" do
      pending
    end
  end
end
