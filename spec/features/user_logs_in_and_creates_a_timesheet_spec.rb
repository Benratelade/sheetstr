# frozen_string_literal: true

require "rails_helper"

describe "An existing user logs in to sheetstr and creates a timesheet", type: :feature do
  before do
    Timecop.freeze(Date.parse("Jan 30 2022"))
  end

  scenario "An existing user comes to Sheetstr, logs in and sees a form to create a Timesheet" do
    Given "Ben already has an account at Sheetstr" do
      @ben = create(:user, email: "ratelade.benjamin@gmail.com", password: "password")
    end

    When "They visit the sign in page and enters the wrong credentials" do
      visit "users/sign_in"
      fill_in("Email", with: "ratelade.benjamin@gmail.com")
      fill_in("Password", with: "some)junk")
      click_button("Log in")
    end

    Then "an error explains that credentials are incorrect" do
      wait_for { focus_on(Support::PageFragments::Flash).messages }.to eq(["Invalid Email or password"])
    end

    When "they enter the correct credentials" do
      login_as(@ben)
    end

    Then "They are welcomed to Sheetstr" do
      wait_for do
        focus_on(Support::PageFragments::Headers).page_header
      end.to eq("Welcome ratelade.benjamin@gmail.com")
    end

    And "a form for a new timesheet is displayed for the current week" do
      subtitle = page.find("h3").text
      wait_for { subtitle }.to eq("New Timesheet")

      start_date = find_field("Start date")
      end_date = find_field("End date")

      wait_for { start_date.value }.to eq("2022-01-24")
      wait_for { end_date.value }.to eq("2022-01-30")
    end

    When "They submit the form" do
      click_button("Save")
    end

    Then "They see a summary of the week's work" do
      wait_for { focus_on(Support::PageFragments::Headers).page_header }.to(
        eq("Timesheet for Monday, January 24 2022 to Sunday, January 30 2022"),
      )

      wait_for { focus_on(Support::PageFragments::Timesheet).summary }.to(
        eq(
          {
            "Total hours worked (decimal)" => ["0"],
            "Duration (in hours)" => ["0 hours 0 minutes"],
            "Total revenue" => ["$0.0"],
          },
        ),
      )
    end

    When "they click to add an item" do
      click_on("Add item")
    end

    Then "a form for a line item is shown" do
      wait_for { focus_on(Support::PageFragments::Form).form.labels }.to eq(
        ["Weekday", "Description", "Start time", "End time", "Hourly rate"],
      )
    end

    When "they fill out and submit the form" do
      select("tuesday", from: "Weekday")
      fill_in("Description", with: "On-site shooting")
      fill_in("Start time", with: "08:30a.m.")
      fill_in("End time", with: "12:50p.m.")
      fill_in("Hourly rate", with: "27")
      focus_on(Support::PageFragments::Form).form.submit
    end

    Then "they see the updated summary" do
      wait_for { focus_on(Support::PageFragments::Timesheet).summary }.to(
        eq(
          {
            "Total hours worked (decimal)" => ["4.33"],
            "Duration (in hours)" => ["4 hours 20 minutes"],
            "Total revenue" => ["$117.0"],
          },
        ),
      )
    end

    And "there is a breakdown showing the new line item" do
      wait_for do
        focus_on(Support::PageFragments::Timesheet).daily_breakdown
      end.to eq(
        {
          "Tuesday" => [
            {
              "description" => "On-site shooting",
              "hourly rate" => "27.0",
              "subtotal" => "117.00",
              "total decimal hours" => "4.33",
            },
          ],
        },
      )
    end

    When "They click on the button to go back to their Timesheets" do
      page.click_link("View my timesheets")
    end

    Then "They are taken to a list of all their Timesheets" do
      wait_for { page.current_url }.to end_with("/timesheets")
    end

    And "a list of all their timesheets is shown" do
      wait_for do
        focus_on(Support::PageFragments::Headers).page_header
      end.to eq("Timesheets for ratelade.benjamin@gmail.com")
      timesheets_table = page.find("#timesheets-table")
      table_headers = timesheets_table.find_all("thead th").map(&:text)

      wait_for { table_headers }.to eq(
        [
          "Start Date",
          "End Date",
          "Total Decimal Hours",
          "Total Revenue",
          "Actions",
        ],
      )
      rows_data = timesheets_table.find_all("tbody tr td").map(&:text)
      wait_for { rows_data }.to eq(
        [
          "Monday, 24 Jan 2022",
          "Sunday, 30 Jan 2022",
          "4.33 hours",
          "$117.00",
          "View Edit",
        ],
      )
    end
  end
end
