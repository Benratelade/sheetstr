# frozen_string_literal: true

require "rails_helper"

describe "A new user signs up to sheetstr and creates their first timesheet", type: :feature do
  before do
    Timecop.freeze(Date.parse("Jan 30 2022"))
  end

  scenario "A new user comes to Sheetstr for the first time, create an account and see the welcome page" do
    When "They visit the sign up page" do
      visit "users/sign_up"
    end

    And "they fill up the sign up form" do
      fill_in("Email", with: "ratelade.benjamin@gmail.com")
      fill_in("Password", with: "password")
      fill_in("Password confirmation", with: "password")
      focus_on(Support::PageFragments::Form).form.submit
    end

    Then "a screen asks them to select their timezone" do
      wait_for do
        focus_on(Support::PageFragments::Headers).page_header
      end.to eq("Please select your timezone")
    end

    When "they select and confirm their timezone" do
      select("Sydney", from: "Timezone")
      focus_on(Support::PageFragments::Form).form.submit
    end

    And "They are taken to a new Timesheet page with their email showing, for this week" do
      wait_for do
        focus_on(Support::PageFragments::Headers).page_header
      end.to eq("Welcome ratelade.benjamin@gmail.com")

      timesheet_title = find_all("h3").first
      expect(timesheet_title.text).to eq("New Timesheet")

      start_date = find_field("Start date")
      end_date = find_field("End date")

      expect(start_date.value).to eq("2022-01-24")
      expect(end_date.value).to eq("2022-01-30")
    end

    When "they submit the form" do
      focus_on(Support::PageFragments::Form).form.submit
    end

    And "they add a line item" do
      click_on("Add item")
      wait_for { focus_on(Support::PageFragments::Form).form.labels }.to eq(
        ["Start date", "Description", "Start time", "End time", "Hourly rate"],
      )

      select("Tuesday", from: "Start date")
      fill_in("Description", with: "On-site shooting")
      fill_in("Start time", with: "08:00a.m.")
      fill_in("End time", with: "05:00p.m.")
      fill_in("Hourly rate", with: "25")
      focus_on(Support::PageFragments::Form).form.submit
    end

    Then "They see a summary of each day's work" do
      wait_for do
        focus_on(Support::PageFragments::Headers).page_header
      end.to eq("Timesheet for Monday, January 24 2022 to Sunday, January 30 2022")

      wait_for do
        focus_on(Support::PageFragments::Timesheet).summary
      end.to eq(
        {
          "Total hours worked (decimal)" => ["9.0"],
          "Duration (in hours)" => ["9 hours 0 minutes"],
          "Total revenue" => ["$225.0"],
        },
      )
    end
  end
end
