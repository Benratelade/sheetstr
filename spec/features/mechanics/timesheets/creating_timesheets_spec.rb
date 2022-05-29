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

    Then "an empty list of timesheets is displayed" do
      wait_for { focus_on(Support::PageFragments::Table).table.data }.to eq([])
    end

    When "she clicks on a link to create a new timesheet" do
      click_on("Create timesheet")
    end

    Then "a form for a new timesheet is displayed" do
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
          "Hourly rate",
        ],
      )
    end

    And "the start and end dates are prefilled for this calendar week" do
      wait_for { focus_on(Support::PageFragments::Form).form.value_for("Start date") }.to eq("2022-01-24")
      wait_for { focus_on(Support::PageFragments::Form).form.value_for("End date") }.to eq("2022-01-30")
    end

    When "she edits the start date to a date that is not a Monday" do
      fill_in("Start date", with: "23-01-2022")
    end

    And "she edits the end date to anything other than 6 days from the start date and submits" do
      fill_in("Start date", with: "25-01-2022")
      focus_on(Support::PageFragments::Form).form.submit
    end

    Then "a validation error is displayed for both errors" do
      wait_for { focus_on(Support::PageFragments::Flash).error_messages }.to eq(
        [
          "Timesheets must start on a Monday",
          "Timesheets must be 7 days long",
        ],
      )
    end

    When "she fills out the form and submits it" do
      days_sections = page.find_all("[data-testid^=day-section-]")
      days_sections.each do |day_section|
        day_section.fill_in("Start time", with: "08:00am")
        day_section.fill_in("End time", with: "17:00")
        day_section.fill_in("Hourly rate", with: "25")
      end
      click_button("Submit")
    end

    Then "a summary of the new timesheet is displayed" do
      page_title = find("h2")
      expect(page_title.text).to eq("Timesheet for Monday, January 24 2022 to Sunday, January 30 2022")
    end

    When "she goes to the list of her timesheets" do
      click_on("View my timesheets")
    end

    Then "the new timesheet is displayed" do
      wait_for { focus_on(Support::PageFragments::Table).table.data }.to eq(
        [
          "Start Date" => "Monday, 24 Jan 2022",
          "End Date" => "Sunday, 30 Jan 2022",
          "Total Decimal Hours" => "63.0 hours",
          "Total Revenue" => "$1575.0",
          "Actions" => "View Edit",
        ],
      )
    end
  end
end
