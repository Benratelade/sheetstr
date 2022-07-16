# frozen_string_literal: true

require "rails_helper"

describe "Editing a timesheet's line items", type: :feature do
  before do
    @otolose = create(:user)

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
      start_time: Time.iso8601("2022-01-24T08:00:00+10:00"),
      end_time: Time.iso8601("2022-01-24T12:30:00+10:00"),
    )

    create(
      :line_item,
      timesheet: @timesheet,
      weekday: "tuesday",
      description: "office hours",
      hourly_rate: 24,
      start_time: Time.iso8601("2022-01-25T08:00:00+10:00"),
      end_time: Time.iso8601("2022-01-25T12:30:00+10:00"),
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
          "Duration (decimal)" => "9.00",
          "Duration (in hours)" => "(9 hours 0 minutes)",
          "Total revenue" => "$ 216.00",
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
            },
          ],
          "Tuesday" => [
            {
              "description" => "office hours",
              "hourly rate" => "24.0",
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
      select("tuesday", from: "Weekday")
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
          "Duration (decimal)" => "12.50",
          "Duration (in hours)" => "(12 hours 30 minutes)",
          "Total revenue" => "$ 324.00",
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
              "description" => "office hours",
              "hourly rate" => "24.0",
              "subtotal" => "108.00",
              "total decimal hours" => "4.50",
            }, {
              "description" => "On-site shooting",
              "hourly rate" => "27.0",
              "subtotal" => "216.00",
              "total decimal hours" => "8.00",
            },
          ],
        },
      )
    end
  end
end
