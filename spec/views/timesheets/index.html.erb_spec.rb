# frozen_string_literal: true

require "rails_helper"

describe "timesheets/index", type: :view do
  before do
    @current_user = double("the user", email: "user_email")
    allow(controller).to receive(:current_user).and_return(@current_user)
    @timesheets = double("Timesheets")
    allow(@timesheets).to receive(:each).and_return([])
  end

  it "Displays a title that contains the currently logged-in user's email" do
    render

    expect(rendered).to have_css("h2#page-header", text: "Timesheets for user_email")
  end

  it "renders a table with headers for each columns" do
    render

    expect(rendered).to have_css("table#timesheets-table")
    headers = Capybara.string(rendered).find_all("table thead th").map(&:text)
    expect(headers).to eq(
      [
        "Start Date",
        "End Date",
        "Total Decimal Hours",
        "Total Revenue"
      ],
    )
  end

  it "renders a row for each timesheet" do
    start_date = double("A start date")
    end_date = double("An end date")
    expect(Utils::DateTimeFormatter).to receive(:format_date).with(start_date).and_return("Formatted start date")
    expect(Utils::DateTimeFormatter).to receive(:format_date).with(end_date).and_return("Formatted end date")
    @timesheets = [
      double(
        "a timesheet",
        start_date: start_date,
        end_date: end_date,
        total_decimal_hours: 30.3,
        total_revenue: 727.2,
      )
    ]
    render

    page = Capybara.string(rendered)
    timesheet_rows = page.find_all("tbody tr")
    expect(timesheet_rows.count).to eq(1)
    timesheets_data = timesheet_rows.first.find_all("td").map do |td|
      td.text
    end
    expect(timesheets_data).to eq(
      [
        "Formatted start date",
        "Formatted end date",
        "30.3 hours",
        "$727.2"
      ],
    )
  end
end
