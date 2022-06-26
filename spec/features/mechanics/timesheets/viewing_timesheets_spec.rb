# frozen_string_literal: true

require "rails_helper"

describe "An existing user views a timesheet from the index page", type: :feature do
  before do
    @otolose = create(:user)
    @arthur = create(:user)

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
      weekday: "monday",
      description: "office hours",
      hourly_rate: 24,
      start_time: Time.iso8601("2022-01-24T08:00:00+10:00"),
      end_time: Time.iso8601("2022-01-24T12:30:00+10:00"),
    )

    create(
      :line_item,
      timesheet: @timesheet_1,
      weekday: "monday",
      description: "on-site shooting",
      hourly_rate: 30,
      start_time: Time.iso8601("2022-01-24T12:30:00+10:00"),
      end_time: Time.iso8601("2022-01-24T18:30:00+10:00"),
    )

    create(
      :line_item,
      timesheet: @timesheet_1,
      weekday: "tuesday",
      description: "shooting",
      hourly_rate: 30,
      start_time: Time.iso8601("2022-01-25T08:00:00+10:00"),
      end_time: Time.iso8601("2022-01-25T14:30:00+10:00"),
    )

    create(
      :line_item,
      timesheet: @timesheet_1,
      weekday: "thursday",
      description: "office hours",
      hourly_rate: 24,
      start_time: Time.iso8601("2022-01-27T08:00:00+10:00"),
      end_time: Time.iso8601("2022-01-27T14:30:00+10:00"),
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

    Then "They see a summary of the week's work" do
      wait_for do
        focus_on(Support::PageFragments::Headers).page_header
      end.to eq("Timesheet for Monday, January 24 2022 to Sunday, January 30 2022")

      wait_for { focus_on(Support::PageFragments::Timesheet).summary }.to eq(
        {
          "Duration (decimal)" => "23.50",
          "Duration (in hours)" => "(23 hours 30 minutes)",
          "Total revenue" => "$ 639.00",
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
              "hourly rate" => "24.0",
              "subtotal" => "108.00",
              "total decimal hours" => "4.50",
            }, {
              "description" => "on-site shooting",
              "hourly rate" => "30.0",
              "subtotal" => "180.00",
              "total decimal hours" => "6.00",
            },
          ],
          "Tuesday" => [
            {
              "description" => "shooting",
              "hourly rate" => "30.0",
              "subtotal" => "195.00",
              "total decimal hours" => "6.50",
            },
          ],
          "Thursday" => [
            {
              "description" => "office hours",
              "hourly rate" => "24.0",
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
    before do
      create(
        :line_item,
        timesheet: @timesheet_1,
        weekday: "tuesday",
        description: "office hours",
        hourly_rate: 24,
        start_time: Time.iso8601("2022-02-24T08:00:00+10:00"),
        end_time: Time.iso8601("2022-02-24T12:30:00+10:00"),
      )
    end

    scenario "Otolose views the timesheet and sees line items grouped by description and hourly rate" do
      When "a logged in user visits the timesheet" do
        login_as(@otolose)
        visit(timesheet_path(@timesheet_1))
      end

      Then "a summary of unique line items is displayed" do
        pending "need to add a summary of combined line items"
        wait_for { 5 }.to eq(2)
      end
    end
  end
end
