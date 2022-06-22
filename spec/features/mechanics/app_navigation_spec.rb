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
    pending "Need to implement logout button"
  end
end
