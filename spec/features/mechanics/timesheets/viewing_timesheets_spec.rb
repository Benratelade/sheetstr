# frozen_string_literal: true

require "rails_helper"

describe "An existing user views a timesheet from the index page", type: :feature do
  before do
    @otolose = create(:user)
    create(:user_configuration, timezone_identifier: "UTC", user: @otolose)
    @arthur = create(:user)
    create(:user_configuration, timezone_identifier: "UTC", user: @arthur)

    @timesheet_1 = create(
      :timesheet,
      user: @otolose,
      start_date: Date.parse("Jan 24 2022"),
      end_date: Date.parse("Jan 30 2022"),
    )

    create(
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

    @arthur_timesheet = create(
      :timesheet,
      user: @arthur,
    )

    create(
      :line_item,
      timesheet: @timesheet_1,
      description: "office hours",
      hourly_rate: 24,
      start_time: Time.iso8601("2022-01-24T08:00:00Z"),
      end_time: Time.iso8601("2022-01-24T12:30:00Z"),
    )

    create(
      :line_item,
      timesheet: @timesheet_1,
      description: "shooting",
      hourly_rate: 30,
      start_time: Time.iso8601("2022-01-24T12:30:00Z"),
      end_time: Time.iso8601("2022-01-24T18:30:00Z"),
    )

    create(
      :line_item,
      timesheet: @timesheet_1,
      description: "shooting",
      hourly_rate: 30,
      start_time: Time.iso8601("2022-01-25T08:00:00Z"),
      end_time: Time.iso8601("2022-01-25T14:30:00Z"),
    )

    create(
      :line_item,
      timesheet: @timesheet_1,
      description: "office hours",
      hourly_rate: 24,
      start_time: Time.iso8601("2022-01-27T08:00:00Z"),
      end_time: Time.iso8601("2022-01-27T14:30:00Z"),
    )
  end

  scenario "Otolose looks at an existing timesheet" do
    When "a logged in user visits the list of her timesheets" do
      login_as(@otolose)
      visit(timesheets_path)
    end

    Then "a list of all her timesheets is shown, ordered by start date, with most recent timesheets first" do
      wait_for { focus_on(Support::PageFragments::Table).table.data }.to eq(
        [
          {
            "Start Date" => "Monday, 07 Feb 2022",
            "End Date" => "Sunday, 13 Feb 2022",
            "Total Decimal Hours" => "0.00 hours",
            "Total Revenue" => "$0.00",
            "Actions" => "View Edit",
          }, {
            "Start Date" => "Monday, 31 Jan 2022",
            "End Date" => "Sunday, 06 Feb 2022",
            "Total Decimal Hours" => "0.00 hours",
            "Total Revenue" => "$0.00",
            "Actions" => "View Edit",
          }, {
            "Start Date" => "Monday, 24 Jan 2022",
            "End Date" => "Sunday, 30 Jan 2022",
            "Total Decimal Hours" => "23.50 hours",
            "Total Revenue" => "$639.00",
            "Actions" => "View Edit",
          },
        ],
      )
    end

    And "she clicks to view one of her existing timesheets" do
      focus_on(Support::PageFragments::Table).table.rows.last.go_to("View")
    end

    Then "she sees a summary of the week's work" do
      wait_for do
        focus_on(Support::PageFragments::Headers).page_header
      end.to eq("Timesheet for Monday, January 24 2022 to Sunday, January 30 2022")

      wait_for { focus_on(Support::PageFragments::Timesheet).summary }.to eq(
        {
          "Total hours worked (decimal)" => ["23.5"],
          "Duration (in hours)" => ["23 hours 30 minutes"],
          "Total revenue" => ["$639.0"],
        },
      )
    end

    And "a summary of each day's work is displayed" do
      wait_for do
        focus_on(Support::PageFragments::Timesheet).daily_breakdown
      end.to eq(
        {
          "Monday" => [
            {
              "description" => "office hours",
              "date" => "Monday, 24 January 2022",
              "hourly rate" => "24.00",
              "subtotal" => "108.00",
              "total decimal hours" => "4.50",
            }, {
              "description" => "shooting",
              "date" => "Monday, 24 January 2022",
              "hourly rate" => "30.00",
              "subtotal" => "180.00",
              "total decimal hours" => "6.00",
            },
          ],
          "Tuesday" => [
            {
              "description" => "shooting",
              "date" => "Tuesday, 25 January 2022",
              "hourly rate" => "30.00",
              "subtotal" => "195.00",
              "total decimal hours" => "6.50",
            },
          ],
          "Thursday" => [
            {
              "description" => "office hours",
              "date" => "Thursday, 27 January 2022",
              "hourly rate" => "24.00",
              "subtotal" => "156.00",
              "total decimal hours" => "6.50",
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

  context "when there are line items with the same description and hourly rate" do
    scenario "Otolose views the timesheet and sees line items grouped by description and hourly rate" do
      When "a logged in user visits the timesheet" do
        login_as(@otolose)
        visit(timesheet_path(@timesheet_1))
      end

      Then "a summary of unique line items is displayed" do
        wait_for do
          focus_on(Support::PageFragments::Timesheet).items_summary
        end.to eq(
          [
            {
              "description" => "office hours",
              "hourly rate" => "$24.00 per hour",
              "total decimal hours" => "11.00 hours",
              "subtotal" => "$264.00",
            }, {
              "description" => "shooting",
              "hourly rate" => "$30.00 per hour",
              "total decimal hours" => "12.50 hours",
              "subtotal" => "$375.00",
            },
          ],
        )
      end
    end
  end
end
