# frozen_string_literal: true

require "rails_helper"

describe "An existing user views a timesheet from the index page", type: :feature do
  before do
    @otolose = create(:user)
    @timesheet = create(
      :timesheet,
      user: @otolose,
      start_date: Date.parse("Jan 24 2022"),
      end_date: Date.parse("Jan 30 2022"),
    )

    create(
      :line_item,
      timesheet: @timesheet,
      weekday: "monday",
      description: "office hours",
      hourly_rate: 24,
      start_time: Time.iso8601("2022-01-24T08:00:00+10:00"),
      end_time: Time.iso8601("2022-01-24T17:30:00+10:00"),
    )

    create(
      :line_item,
      timesheet: @timesheet,
      weekday: "tuesday",
      description: "shooting",
      hourly_rate: 30,
      start_time: Time.iso8601("2022-01-25T08:00:00+10:00"),
      end_time: Time.iso8601("2022-01-25T14:30:00+10:00"),
    )

    create(
      :line_item,
      timesheet: @timesheet,
      weekday: "thursday",
      description: "office hours",
      hourly_rate: 24,
      start_time: Time.iso8601("2022-01-27T08:00:00+10:00"),
      end_time: Time.iso8601("2022-01-27T14:30:00+10:00"),
    )
  end

  scenario "Otolose looks at an existing timesheet" do
    When "Otolose is logged in and visits the list of her timesheets" do
      login_as(@otolose)
      visit(timesheets_path)
    end

    And "she clicks to view one of her existing timesheets" do
      focus_on(Support::PageFragments::Table).table.rows.first.go_to("View")
    end

    Then "They see a summary of the week's work" do
      page_title = find("h2")
      wait_for { page_title.text }.to eq("Timesheet for Monday, January 24 2022 to Sunday, January 30 2022")

      summary_section = find("section[data-test_id=summary-section]")
      hours_summary = summary_section.find("#total-time-section")
      decimal_value = hours_summary.find("#decimal-value")
      hourly_value = hours_summary.find("#hourly-value")

      wait_for { decimal_value.text }.to eq("22.50")
      wait_for { hourly_value.text }.to eq("(22 hours 30 minutes)")

      revenue_summary = summary_section.find("#total-revenue-section")
      dollar_value = revenue_summary.find("#total-revenue")

      wait_for { dollar_value.text }.to eq("$ 579.00")
    end

    And "a summary of each day's work is displayed" do
      pending
      wait_for do
        focus_on(Support::PageFragments::Timesheet).daily_breakdown
      end.to eq(
        {
          "monday" => [
            {
              "description" => "office hours",
              "hourly rate" => "24.0",
              "subtotal" => "228.0",
              "total decimal hours" => "9.5",
            },
          ],
          "tuesday" => [
            {
              "description" => "office hours",
              "hourly rate" => "24.0",
              "subtotal" => "156.0",
              "total decimal hours" => "6.5",
            },
          ],
          "thursday" => [
            {
              "description" => "shooting",
              "hourly rate" => "30.0",
              "subtotal" => "195.0",
              "total decimal hours" => "6.5",
            },
          ],
        },
      )
    end

    When "she clicks the link to go back to the list of timesheets" do
      click_on("View my timesheets")
    end

    Then "she is back on the list of timesheets" do
      wait_for do
        focus_on(Support::PageFragments::Headers).page_header
      end.to eq("Timesheets for #{@otolose.email}")
    end
  end
end
