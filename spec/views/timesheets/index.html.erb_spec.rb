# frozen_string_literal: true

require "rails_helper"

describe "timesheets/index", type: :view do
  before do
    @current_user = double("the user", email: "user_email")
    allow(controller).to receive(:current_user).and_return(@current_user)
    @timesheets = double("Timesheets")
    allow(@timesheets).to receive(:each).and_return([])
    allow(view).to receive(:render).and_call_original
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
        "Total Revenue",
        "Actions",
      ],
    )
  end

  it "renders a link to create new timesheets" do
    button_component = double("a button component")

    expect(Utilities::Buttons::ButtonComponent).to receive(:new).with(
      text: "Create timesheet",
      link: "http://test.host/timesheets/new",
      style: "primary",
    ).and_return(button_component)
    expect(view).to receive(:render).with(button_component) { "A rendered button component" }
    render

    page = Capybara.string(rendered)
    expect(page).to have_content("A rendered button component")
  end

  context "when there ARE timesheets" do
    before do
      @start_date = double("A start date")
      @end_date = double("An end date")
      allow(Utils::DateTimeFormatter).to receive(:format_date).and_return("Formatted start date")
      allow(Utils::DateTimeFormatter).to receive(:format_date).and_return("Formatted end date")
      @timesheet = double(
        "a timesheet",
        id: "timesheet-id",
        start_date: @start_date,
        end_date: @end_date,
        total_decimal_hours: 30.3,
        total_revenue: 727.2,
      )
      @timesheets = [@timesheet]
    end

    it "renders a row for each timesheet" do
      expect(Utils::DateTimeFormatter).to receive(:format_date).with(@start_date).and_return("Formatted start date")
      expect(Utils::DateTimeFormatter).to receive(:format_date).with(@end_date).and_return("Formatted end date")

      render

      page = Capybara.string(rendered)
      timesheet_rows = page.find_all("tbody tr")
      expect(timesheet_rows.count).to eq(1)
      timesheets_data = timesheet_rows.first.find_all("td").map(&:text)
      expect(timesheets_data).to eq(
        [
          "Formatted start date",
          "Formatted end date",
          "30.30 hours",
          "$727.20",
          "View Edit",
        ],
      )
    end

    it "shows decimal things with a precision of 2" do
      allow(Utils::DateTimeFormatter).to receive(:format_date).with(@start_date).and_return("Formatted start date")
      allow(Utils::DateTimeFormatter).to receive(:format_date).with(@end_date).and_return("Formatted end date")
      allow(@timesheet).to receive(:total_decimal_hours).and_return(BigDecimal("30.3333333"))
      allow(@timesheet).to receive(:total_revenue).and_return(BigDecimal("729.3333333"))

      render

      page = Capybara.string(rendered)
      timesheet_rows = page.find_all("tbody tr")
      expect(timesheet_rows.count).to eq(1)
      timesheets_data = timesheet_rows.first.find_all("td").map(&:text)
      expect(timesheets_data).to eq(
        [
          "Formatted start date",
          "Formatted end date",
          "30.33 hours",
          "$729.33",
          "View Edit",
        ],
      )
    end

    it "renders a link to VIEW a timesheet in the last column" do
      render

      page = Capybara.string(rendered)
      show_link = page.find_all("tbody tr").first.find("td:last-child").find_link("View")
      expect(show_link["href"]).to eq("http://test.host/timesheets/timesheet-id")
    end

    it "renders a link to EDIT a timesheet in the last column" do
      pending

      render

      page = Capybara.string(rendered)
      edit_link = page.find_all("tbody tr").first.find("td:last-child").find_link("Edit")
      expect(edit_link["href"]).to eq("http://test.host/timesheets/timesheet-id/edit")
    end
  end
end
