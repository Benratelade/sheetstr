# frozen_string_literal: true

require "rails_helper"

describe "An existing user logs in to sheetstr and creates a timesheet", type: :feature do
  before do
    Timecop.freeze(Date.parse("Jan 30 2022"))
  end

  scenario "An existing user comes to Sheetstr, logs in and sees a list of timesheets" do
    Given "Ben already has an account at Sheetstr" do
      @ben = create(:user, email: "ratelade.benjamin@gmail.com", password: "password")
    end

    When "They visit the sign in page" do
      visit "users/sign_in"
    end

    And "they sign in" do
      fill_in("Email", with: "ratelade.benjamin@gmail.com")
      fill_in("Password", with: "password")
      click_on("Log in")
    end

    Then "They are taken to a new Timesheet page with their email showing, for this week" do
      page_title = find("h2")
      expect(page_title.text).to eq("Welcome ratelade.benjamin@gmail.com")

      timesheet_title = find_all("h3").first
      expect(timesheet_title.text).to eq("New Timesheet")

      start_date = find_field("Start date", readonly: true)
      expect(start_date).to be_readonly
      end_date = find_field("End date", readonly: true)
      expect(end_date).to be_readonly

      expect(start_date.value).to eq("2022-01-24")
      expect(end_date.value).to eq("2022-01-30")
    end

    When "They fill out the form" do
      days_sections = page.find_all("[data-testid^=day-section-]")
      days_sections.each do |day_section|
        day_section.fill_in("Start time", with: "08:00am")
        day_section.fill_in("End time", with: "17:00")
        day_section.fill_in("Hourly rate", with: "25")
      end
      click_button("Submit")
    end

    Then "They see a summary of each day's work" do
      page_title = find("h2")
      expect(page_title.text).to eq("Timesheet for Monday, January 24 2022 to Sunday, January 30 2022")

      summary_section = find("section[data-test_id=summary-section]")
      hours_summary = summary_section.find("#total-time-section")
      decimal_value = hours_summary.find("#decimal-value")
      hourly_value = hours_summary.find("#hourly-value")

      expect(decimal_value.text).to eq("63.00")
      expect(hourly_value.text).to eq("(63 hours 0 minutes)")

      revenue_summary = summary_section.find("#total-revenue-section")
      dollar_value = revenue_summary.find("#total-revenue")

      expect(dollar_value.text).to eq("$ 1575.00")
    end
  end
end
