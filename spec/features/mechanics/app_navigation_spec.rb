# frozen_string_literal: true

require "rails_helper"

describe "Navigating through the app", type: :feature do
  context "When the user is not logged in" do
    scenario "A user who is not logged in explores the top nav" do
      When "A user visits the homepage" do
        visit("/")
      end

      Then "They see a link to log in and a link to sign up" do
        wait_for { focus_on(Support::PageFragments::Navigation).actions }.to eq(
          {
            "Log in" => "http://127.0.0.1:5000/users/sign_in",
            "Sign up" => "http://127.0.0.1:5000/users/sign_up",
          },
        )
      end
    end
  end

  context "When the user IS logged in" do
    before do
      @otolose = create(:user)
    end

    scenario "A user who is logged in sees a logout link" do
      When "A user is signs in" do
        login_as(@otolose)
      end

      Then "a link to view their timesheets is displayed" do
        wait_for { focus_on(Support::PageFragments::Navigation).links }.to eq(
          "Timesheets" => "http://127.0.0.1:5000/timesheets",
        )
      end

      And "there is a logout link in the nav actions section" do
        wait_for { focus_on(Support::PageFragments::Navigation).actions }.to eq(
          {
            "Log out" => "http://127.0.0.1:5000/users/sign_out",
          },
        )
      end

      When "they click on the logout link" do
        click_on("Log out")
      end

      Then "they are taken back to the login page" do
        wait_for { current_path }.to eq("/users/sign_in")
      end

      And "the actions allow him to sign back in" do
        wait_for { focus_on(Support::PageFragments::Navigation).actions }.to eq(
          {
            "Log in" => "http://127.0.0.1:5000/users/sign_in",
            "Sign up" => "http://127.0.0.1:5000/users/sign_up",
          },
        )
      end
    end
  end
end
