# frozen_string_literal: true

require "rails_helper"

describe "A new user signs up to sheetstr", type: :feature do
    scenario 'A new user comes to Sheetstr for the first time, create an account and see the welcome page' do
        When "They visit the sign up page" do
            visit 'users/sign_up'
        end

        And "they fill up the sign up form" do
            fill_in('Email', with: 'ratelade.benjamin@gmail.com')
            fill_in('Password', with: 'password')
            fill_in('Password confirmation', with: 'password')
            click_on("Sign up")
        end

        Then "A user is created" do
            user = User.find_by(email: "ratelade.benjamin@gmail.com")
            expect(user).to be_present
        end

        And "They are taken to a new Timesheet page with their email showing" do
            page_title = find("h2")
            expect(page_title.text).to eq("Welcome ratelade.benjamin@gmail.com")
            
            timesheet_title = find("h3")
            expect(timesheet_title.text).to eq("New Timesheet")
        end
    end
end
