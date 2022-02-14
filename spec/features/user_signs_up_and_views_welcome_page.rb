# frozen_string_literal: true

require "rails_helper"

describe "A new user signs up to sheetstr", type: :feature do
    scenario 'A new user comes to Sheetstr for the first time, create an account and see their welcome page' do
        visit 'sign_up'
    end
end
