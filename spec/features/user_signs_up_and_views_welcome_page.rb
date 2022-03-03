# frozen_string_literal: true

require "rails_helper"

describe "A new user signs up to sheetstr", type: :feature do
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

      start_date = find_field("Start date", disabled: true)
      expect(start_date).to be_disabled
      end_date = find_field("End date", disabled: true)
      expect(end_date).to be_disabled

      expect(start_date.value).to eq("2022-01-24")
      expect(end_date.value).to eq("2022-01-30")
    end
  end
end
