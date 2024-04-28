# frozen_string_literal: true

require "rails_helper"

describe "Editing a timesheet's line items", type: :feature do
  before do
    @otolose = create(:user)
    create(:user_configuration, timezone_identifier: "Sydney", user: @otolose)

    @timesheet = create(
      :timesheet,
      user: @otolose,
      start_date: Date.parse("Jan 31 2022"),
      end_date: Date.parse("Feb 6 2022"),
    )

    @line_item_1 = create(
      :line_item,
      timesheet: @timesheet,
      weekday: "monday",
      description: "office hours",
      hourly_rate: 24,
      start_time: Time.iso8601("2022-01-31T08:00:00+10:00"),
      end_time: Time.iso8601("2022-01-31T12:30:00+10:00"),
    )

    create(
      :line_item,
      timesheet: @timesheet,
      weekday: "tuesday",
      description: "office hours",
      hourly_rate: 24,
      start_time: Time.iso8601("2022-02-01T08:00:00+10:00"),
      end_time: Time.iso8601("2022-02-01T12:30:00+10:00"),
    )
  end

  scenario "An existing user edits line items in a timesheet" do
    When "Otolose views one of her timesheets that has line items" do
      login_as(@otolose)
      visit(timesheets_path)
      focus_on(Support::PageFragments::Timesheet).view(@timesheet)
    end

    Then "she sees the summary of the timesheet" do
      wait_for { focus_on(Support::PageFragments::Timesheet).summary }.to eq(
        {
          "Total hours worked (decimal)" => ["9.0"],
          "Duration (in hours)" => ["9 hours 0 minutes"],
          "Total revenue" => ["$216.0"],
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
              "date" => "Monday, 31 January 2022",
              "hourly rate" => "24.00",
              "subtotal" => "108.00",
              "total decimal hours" => "4.50",
            },
          ],
          "Tuesday" => [
            {
              "description" => "office hours",
              "date" => "Tuesday, 01 February 2022",
              "hourly rate" => "24.00",
              "subtotal" => "108.00",
              "total decimal hours" => "4.50",
            },
          ],
        },
      )
    end

    When "she goes to edit one of the line items" do
      focus_on(Support::PageFragments::Timesheet).edit_line_item(@line_item_1)
    end

    And "she updates the line item details" do
      select("Tuesday", from: "Start date")
      fill_in("Description", with: "On-site shooting")
      fill_in("Start time", with: "08:30a.m.")
      fill_in("End time", with: "04:30p.m.")
      fill_in("Hourly rate", with: "27")
      focus_on(Support::PageFragments::Form).form.submit
    end

    Then "A message shows that the update worked" do
      wait_for { focus_on(Support::PageFragments::Flash).messages }.to eq(["Line item was updated"])
    end

    And "the summary of the timesheet is updated" do
      wait_for { focus_on(Support::PageFragments::Timesheet).summary }.to eq(
        {
          "Total hours worked (decimal)" => ["12.5"],
          "Duration (in hours)" => ["12 hours 30 minutes"],
          "Total revenue" => ["$324.0"],
        },
      )
    end

    And "the summary for each day also reflects the changes" do
      wait_for do
        focus_on(Support::PageFragments::Timesheet).daily_breakdown
      end.to eq(
        {
          "Tuesday" => [ 
            {
              "description" => "On-site shooting",
              "date" => "Tuesday, 01 February 2022",
              "hourly rate" => "27.00",
              "subtotal" => "216.00",
              "total decimal hours" => "8.00",
            },
            {
              "description" => "office hours",
              "date" => "Tuesday, 01 February 2022",
              "hourly rate" => "24.00",
              "subtotal" => "108.00",
              "total decimal hours" => "4.50",
            }
          ],
        },
      )
    end
  end

  context "An error occurs during the update" do
    scenario "When the timesheet doesn't exist" do
      When "Otolose views one of her timesheets that has line items" do
        login_as(@otolose)
        visit(timesheets_path)
        focus_on(Support::PageFragments::Timesheet).view(@timesheet)
      end

      Then "she sees the summary of the timesheet" do
        wait_for { focus_on(Support::PageFragments::Timesheet).summary }.to eq(
          {
            "Total hours worked (decimal)" => ["9.0"],
            "Duration (in hours)" => ["9 hours 0 minutes"],
            "Total revenue" => ["$216.0"],
          },
        )
      end

      When "she goes to edit one of the line items" do
        focus_on(Support::PageFragments::Timesheet).edit_line_item(@line_item_1)
      end

      And "the timesheet has been deleted in the meantime" do
        @timesheet.delete
      end

      And "she presses save" do
        focus_on(Support::PageFragments::Form).form.submit
      end

      Then "a 404 error page is displayed" do
        wait_for { focus_on(Support::PageFragments::ErrorPage).error_code }.to eq("404")
      end
    end

    scenario "When the timesheet exists but the line item doesn't" do
      When "Otolose views one of her timesheets that has line items" do
        login_as(@otolose)
        visit(timesheets_path)
        focus_on(Support::PageFragments::Timesheet).view(@timesheet)
      end

      Then "she sees the summary of the timesheet" do
        wait_for { focus_on(Support::PageFragments::Timesheet).summary }.to eq(
          {
            "Total hours worked (decimal)" => ["9.0"],
            "Duration (in hours)" => ["9 hours 0 minutes"],
            "Total revenue" => ["$216.0"],
          },
        )
      end

      When "she goes to edit one of the line items" do
        focus_on(Support::PageFragments::Timesheet).edit_line_item(@line_item_1)
      end

      And "the line item has been deleted in the meantime" do
        @line_item_1.delete
      end

      And "she presses save" do
        focus_on(Support::PageFragments::Form).form.submit
      end

      Then "a 404 error page is displayed" do
        wait_for { focus_on(Support::PageFragments::ErrorPage).error_code }.to eq("404")
      end
    end
  end
end
