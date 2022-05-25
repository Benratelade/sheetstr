# frozen_string_literal: true

require "rails_helper"

describe "Someone visits the homepage, and sees the options to log in or sign up", type: :feature do
  scenario "Someone visits the app's homepage" do
    When "They visit the app's homepage" do
      visit(root_path)
    end

    Then "They are given the option to log in or sign up" do
      actions = page.find_all(".login-options a").map(&:text)
      expect(actions).to eq(
        [
          "Log in",
          "Sign up",
        ],
      )
    end

    When "They click on Log in" do
      click_link("Log in")
    end

    Then "they are taken to the log in page." do
      expect(page).to have_current_path(new_user_session_path)
    end

    When "They go back and click on the Sign up link" do
      page.go_back
      click_link("Sign up")
    end

    Then "They are taken to the Sign up page" do
      expect(page).to have_current_path(new_user_registration_path)
    end
  end
end
