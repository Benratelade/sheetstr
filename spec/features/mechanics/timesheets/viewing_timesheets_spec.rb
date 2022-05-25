# frozen_string_literal: true

require "rails_helper"

describe "An existing user views a timesheet from the index page", type: :feature do
  before do
    @otolose = create(:user)
    create(
      :timesheet, 
      user: @otolose, 
      start_date: Date.parse("Jan 24 2022"), 
      end_date: Date.parse("Jan 30 2022"), 
    )
  end
  
  scenario "Otolose looks at an existing timesheet" do
    When "Otolose is logged in and visits the list of her timesheets" do
      login_as(@otolose)
      visit(timesheets_path)
    end

    And "she clicks to view one of her existing timesheets" do
      focus_on(Support::PageFragments::Table).table.rows.first.go_to("View")
    end

    Then "They see a summary of each day's work" do
      pending
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

    When "she clicks the link to go back to the list of timesheets" do
      click_on("View my timesheets")
    end

    Then "she is back on the list of timesheets" do
      wait_for do
        focus_on(Support::PageFragments::Headers).page_header
      end.to eq("Timesheets for #{@otolose.email}")
    end
  end
end
