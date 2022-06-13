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
        ],
      )
    end

    And "the start and end dates are prefilled for this calendar week" do
      wait_for { focus_on(Support::PageFragments::Form).form.value_for("Start date") }.to eq("2022-01-24")
      wait_for { focus_on(Support::PageFragments::Form).form.value_for("End date") }.to eq("2022-01-30")
    end

    When "she edits the start date to a date that is not a Monday" do
      fill_in("Start date", with: Time.iso8601("2022-01-23T13:00:00"))
    end

    And "she edits the end date to anything other than 6 days from the start date and submits" do
      fill_in("End date", with: Time.iso8601("2022-01-25T13:00:00"))
      focus_on(Support::PageFragments::Form).form.submit
    end

    Then "a validation error is displayed for both errors" do
      wait_for { focus_on(Support::PageFragments::Flash).messages }.to eq(
        [
          "Timesheets must start on a Monday",
          "Timesheets must be 7 days long",
        ],
      )
    end

    When "she corrects the dates to match a week starting on Monday" do
      fill_in("Start date", with: Time.iso8601("2022-01-24T13:00:00"))
      fill_in("End date", with: Time.iso8601("2022-01-30T13:00:00"))
      focus_on(Support::PageFragments::Form).form.submit
    end

    Then "the show page for the timesheet is shown" do
      wait_for do
        focus_on(Support::PageFragments::Headers).page_header
      end.to eq("Timesheet for Monday, January 24 2022 to Sunday, January 30 2022")
      @timesheet = Timesheet.first
    end

    When "she clicks to add an item" do
      click_on("Add item")
    end

    Then "a form for a new item is displayed" do
      wait_for { focus_on(Support::PageFragments::Form).form.labels }.to eq(
        ["Weekday", "Description", "Start time", "End time", "Hourly rate"],
      )
    end

    When "she fills out the form and submits it" do
      select("tuesday", from: "Weekday")
      fill_in("Description", with: "On-site shooting")
      fill_in("Start time", with: "08:30a.m.")
      fill_in("End time", with: "12:30p.m.")
      fill_in("Hourly rate", with: "27")
      focus_on(Support::PageFragments::Form).form.submit
    end

    Then "the timesheet summary page is shown" do
      wait_for { current_path }.to eq("/timesheets/#{@timesheet.id}")
    end

    And "the details are updated to include the newly added line item" do
      wait_for do
        summary_section = find("section[data-test_id=summary-section]")
        hours_summary = summary_section.find("#total-time-section")
        decimal_value = hours_summary.find("#decimal-value")
        hourly_value = hours_summary.find("#hourly-value")

        expect(decimal_value.text).to eq("4.00")
        expect(hourly_value.text).to eq("(4 hours 0 minutes)")

        revenue_summary = summary_section.find("#total-revenue-section")
        dollar_value = revenue_summary.find("#total-revenue")

        expect(dollar_value.text).to eq("$ 108.00")
      end
    end

    When "she goes to the list of her timesheets" do
      click_on("View my timesheets")
    end

    Then "the new timesheet is displayed" do
      wait_for { focus_on(Support::PageFragments::Table).table.data }.to eq(
        [
          "Start Date" => "Monday, 24 Jan 2022",
          "End Date" => "Sunday, 30 Jan 2022",
          "Total Decimal Hours" => "4.00 hours",
          "Total Revenue" => "$108.00",
          "Actions" => "View Edit",
        ],
      )
    end
  end
end
