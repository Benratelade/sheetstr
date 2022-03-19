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
      click_on("Sign up")
    end

    Then "A user is created" do
      user = User.find_by(email: "ratelade.benjamin@gmail.com")
      expect(user).to be_present
    end

    And "They are taken to a new Timesheet page with their email showing, for this week" do
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

      expect(decimal_value.text).to eq("63.0")
      expect(hourly_value.text).to eq("(63 hours 0 minutes)")

      revenue_summary = summary_section.find("#total-revenue-section")
      dollar_value = revenue_summary.find("#total-revenue")

      expect(dollar_value.text).to eq("$ 1575.0")
      binding.pry
    end
  end
end
