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
      daily_line_items: [],
    )
    allow(view).to receive(:render).and_call_original
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

    expect(rendered).to have_css("section[id=summary-section]")
  end

  it "Displays the total number of decimal hours worked for that timesheet inside the summary section" do
    allow(@timesheet).to receive(:total_decimal_hours).and_return(27.3333333)

    render

    page = Capybara.string(rendered)
    total = page.find("section[id=summary-section] #total-time-section #decimal-value")
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
    total = page.find("section[id=summary-section] #total-time-section #hourly-value")
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
    total = page.find("section[id=summary-section] #total-revenue-section #total-revenue")
    expect(total.text).to eq("$ 1512.00")
  end

  it "Renders a TimesheetLineItemsSummaryComponent" do
    summary_component = double("A timesheet line items summary component")
    expect(Timesheets::TimesheetLineItemsSummaryComponent).to receive(:new).with(timesheet: @timesheet).and_return(summary_component)
    expect(view).to receive(:render).with(summary_component) { "summary component rendered" }

    render

    page = Capybara.string(rendered)
    summary_section = page.find("#summary-section")
    expect(summary_section).to have_content("summary component rendered")
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
    total = page.find("section[id=summary-section] #total-revenue-section #total-revenue")
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
      @line_item_1 = double(
        "line item 1",
        description: "description 1",
        hourly_rate: 24,
        total_decimal_hours: "total decimal hours 1",
        subtotal: "subtotal 1",
        weekday: "monday",
      )
      @line_item_2 = double(
        "line item 2",
        description: "description 2",
        hourly_rate: 24,
        total_decimal_hours: "total decimal hours 2",
        subtotal: "subtotal 2",
        weekday: "monday",
      )
      @line_item_3 = double(
        "line item 3",
        description: "description 3",
        hourly_rate: 30,
        total_decimal_hours: "total decimal hours 3",
        subtotal: "subtotal 3",
        weekday: "wednesday",
      )
      allow(@timesheet).to receive(:daily_line_items).and_return(
        {
          "monday" => [@line_item_1, @line_item_2],
          "wednesday" => [@line_item_3],
        },
      )
    end

    it "Displays a weekday-summary that contains a list group for each weekday" do
      render

      page = Capybara.string(rendered)
      daily_breakdown = page.find("#daily-breakdown")

      weekday_summaries = daily_breakdown.find_all(".weekday-summary")
      expect(weekday_summaries.count).to eq(2)

      weekday_names = weekday_summaries.map { |summary| summary.find(".weekday").text }
      expect(weekday_names).to eq(%w[monday wednesday])
      expect(weekday_summaries[0]).to have_css("ul.list-group")
    end

    it "Displays a summary of worked hours for each line item" do
      item_1_component = double("Line Item 1 Component")
      item_2_component = double("Line Item 2 Component")
      item_3_component = double("Line Item 3 Component")

      expect(LineItems::LineItemSummaryComponent).to receive(:new).with(@line_item_1).and_return(item_1_component)
      expect(LineItems::LineItemSummaryComponent).to receive(:new).with(@line_item_2).and_return(item_2_component)
      expect(LineItems::LineItemSummaryComponent).to receive(:new).with(@line_item_3).and_return(item_3_component)
      expect(view).to receive(:render).with(item_1_component) { "line item 1 rendered" }
      expect(view).to receive(:render).with(item_2_component) { "line item 2 rendered" }
      expect(view).to receive(:render).with(item_3_component) { "line item 3 rendered" }

      render

      page = Capybara.string(rendered)
      monday_summary = page.find_all(".weekday-summary")[0]

      expect(monday_summary).to have_content("line item 1 rendered")
      expect(monday_summary).to have_content("line item 2 rendered")
    end
  end
end
