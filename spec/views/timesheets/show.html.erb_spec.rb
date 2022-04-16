# frozen_string_literal: true

require "rails_helper"

describe "timesheets/show", type: :view do
  before do
    @current_user = double("the user", email: "ratelade.benjamin@gmail.com")
    allow(controller).to receive(:current_user).and_return(@current_user)

    @timesheet = double(
      "A Timesheet",
      start_date: Date.parse("24 Jan 2022"),
      end_date: Date.parse("30 Jan 2022"),
      total_decimal_hours: "",
      hours_breakdown: {},
      total_revenue: double("some revenue")
    )
  end

  it "Displays the email of the current user" do
    render

    expect(rendered).to have_css("h2", text: "Timesheet for Monday, January 24 2022 to Sunday, January 30 2022")
  end

  it "displays a summary section" do
    render

    expect(rendered).to have_css("section[data-test_id=summary-section]")
  end

  it "Displays the total number of decimal hours worked for that timesheet inside the summary section" do
    line_items = [
      double(
        "line item 1",
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 17:00")
      ),
      double(
        "line item 2",
        start_time: Time.zone.parse("Feb 01 2022 08:00am"),
        end_time: Time.zone.parse("Feb 01 2022 17:00")
      ),
      double(
        "line item 3",
        start_time: Time.zone.parse("Feb 02 2022 08:00am"),
        end_time: Time.zone.parse("Feb 02 2022 17:00")
      )
    ]

    allow(@timesheet).to receive(:line_items).and_return(line_items)
    allow(@timesheet).to receive(:total_decimal_hours).and_return(27.3333333)

    render

    page = Capybara.string(rendered)
    total = page.find("section[data-test_id=summary-section] #total-time-section #decimal-value")
    expect(total.text).to eq("27.33")
  end

  it "Displays the total number of hourly hours worked for that timesheet inside the summary section" do
    line_items = [
      double(
        "line item 1",
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 17:02")
      ),
      double(
        "line item 2",
        start_time: Time.zone.parse("Feb 01 2022 08:00am"),
        end_time: Time.zone.parse("Feb 01 2022 16:15")
      ),
      double(
        "line item 3",
        start_time: Time.zone.parse("Feb 02 2022 08:00am"),
        end_time: Time.zone.parse("Feb 02 2022 17:30")
      )
    ]

    allow(@timesheet).to receive(:line_items).and_return(line_items)
    allow(@timesheet).to receive(:hours_breakdown).and_return(
      {
        hours: 26,
        minutes: 47,
      },
    )

    render

    page = Capybara.string(rendered)
    total = page.find("section[data-test_id=summary-section] #total-time-section #hourly-value")
    expect(total.text).to eq("(26 hours 47 minutes)")
  end

  it "Displays the total revenue for this period" do
    line_items = [
      double(
        "line item 1",
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 17:02")
      ),
      double(
        "line item 2",
        start_time: Time.zone.parse("Feb 01 2022 08:00am"),
        end_time: Time.zone.parse("Feb 01 2022 16:15")
      ),
      double(
        "line item 3",
        start_time: Time.zone.parse("Feb 02 2022 08:00am"),
        end_time: Time.zone.parse("Feb 02 2022 17:30")
      )
    ]

    allow(@timesheet).to receive(:line_items).and_return(line_items)
    allow(@timesheet).to receive(:hours_breakdown).and_return(
      {
        hours: 0,
        minutes: 0,
      },
    )
    allow(@timesheet).to receive(:total_revenue).and_return(1512)

    render

    page = Capybara.string(rendered)
    total = page.find("section[data-test_id=summary-section] #total-revenue-section #total-revenue")
    expect(total.text).to eq("$ 1512.00")
  end

  it "Displays the total revenue with 2 digits after the decimal place" do
    line_items = [
      double(
        "line item 1",
        start_time: Time.zone.parse("Jan 31 2022 08:00am"),
        end_time: Time.zone.parse("Jan 31 2022 17:47")
      ),
    ]

    allow(@timesheet).to receive(:line_items).and_return(line_items)
    allow(@timesheet).to receive(:hours_breakdown).and_return(
      {
        hours: 0,
        minutes: 0,
      },
    )
    allow(@timesheet).to receive(:total_revenue).and_return(BigDecimal("1512.3333333333"))

    render

    page = Capybara.string(rendered)
    total = page.find("section[data-test_id=summary-section] #total-revenue-section #total-revenue")
    expect(total.text).to eq("$ 1512.33")
  end

  it "Displays a section for actions" do
    render

    page = Capybara.string(rendered)
    expect(page).to have_css("section.page-actions")
  end

  it "Displays a link to go to the list of all timesheets" do
    render

    page = Capybara.string(rendered)
    view_timesheets_button = page.find_link("View my timesheets")
    expect(view_timesheets_button["href"]).to eq("/timesheets")
  end
end
