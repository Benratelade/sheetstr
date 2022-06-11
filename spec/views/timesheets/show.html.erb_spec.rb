# frozen_string_literal: true

require "rails_helper"

describe "timesheets/show", type: :view do
  before do
    @current_user = double("the user", email: "ratelade.benjamin@gmail.com")
    allow(controller).to receive(:current_user).and_return(@current_user)

    @timesheet = double(
      "A Timesheet",
      id: "timesheet-id",
      start_date: Date.parse("24 Jan 2022"),
      end_date: Date.parse("30 Jan 2022"),
      total_decimal_hours: "",
      hours_breakdown: {},
      total_revenue: double("some revenue"),
      grouped_line_items: [],
    )
  end

  it "Displays the email of the current user" do
    render

    expect(rendered).to have_css(
      "h2#page-header",
      text: "Timesheet for Monday, January 24 2022 to Sunday, January 30 2022",
    )
  end

  it "displays a summary section" do
    render

    expect(rendered).to have_css("section[data-test_id=summary-section]")
  end

  it "Displays the total number of decimal hours worked for that timesheet inside the summary section" do
    allow(@timesheet).to receive(:total_decimal_hours).and_return(27.3333333)

    render

    page = Capybara.string(rendered)
    total = page.find("section[data-test_id=summary-section] #total-time-section #decimal-value")
    expect(total.text).to eq("27.33")
  end

  it "Displays the total number of hourly hours worked for that timesheet inside the summary section" do
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

  it "Displays a button to add more items" do
    render

    page = Capybara.string(rendered)
    add_item_button = page.find_link("Add item")
    expect(add_item_button["href"]).to eq("/timesheets/timesheet-id/line_items/new")
  end

  it "Displays a daily breakdown section" do
    render

    expect(rendered).to have_css("#daily-breakdown")
  end

  context "When the timesheet has some grouped line items" do
    before do
      allow(@timesheet).to receive(:grouped_line_items).and_return(
        {
          "monday" => [
            double(
              "line item 1",
              description: "description 1",
              hourly_rate: 24,
              total_decimal_hours: "total decimal hours 1",
              subtotal: "subtotal 1",
              weekday: "monday",
            ),
          ],
          "wednesday" => [
            double(
              "line item 2",
              description: "description 2",
              hourly_rate: 30,
              total_decimal_hours: "total decimal hours 2",
              subtotal: "subtotal 2",
              weekday: "wednesday",
            ),
          ],
        },
      )
    end

    it "Displays a weekday-summary that contains a weekday item for each weekday" do
      render

      page = Capybara.string(rendered)
      daily_breakdown = page.find("#daily-breakdown")

      weekday_summaries = daily_breakdown.find_all(".weekday-summary")
      expect(weekday_summaries.count).to eq(2)

      weekday_names = weekday_summaries.map { |summary| summary.find(".weekday").text }
      expect(weekday_names).to eq(%w[monday wednesday])
    end

    it "Displays a summary of worked hours for each line item" do
      render

      page = Capybara.string(rendered)
      weekday_summaries = page.find_all(".weekday-summary")

      monday_line_items = weekday_summaries[0].find_all(".line-item")
      expect(monday_line_items[0].find(".description").text).to eq("description 1")
      expect(monday_line_items[0].find(".hourly-rate").text).to eq("24")
      expect(monday_line_items[0].find(".total-decimal-hours").text).to eq("total decimal hours 1")
      expect(monday_line_items[0].find(".subtotal").text).to eq("subtotal 1")

      wednesday_line_items = weekday_summaries[1].find_all(".line-item")
      expect(wednesday_line_items[0].find(".description").text).to eq("description 2")
      expect(wednesday_line_items[0].find(".hourly-rate").text).to eq("30")
      expect(wednesday_line_items[0].find(".total-decimal-hours").text).to eq("total decimal hours 2")
      expect(wednesday_line_items[0].find(".subtotal").text).to eq("subtotal 2")
    end
  end
end
