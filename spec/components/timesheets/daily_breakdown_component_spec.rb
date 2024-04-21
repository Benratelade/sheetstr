# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timesheets::DailyBreakdownComponent, type: :component do
  before do
    @line_item_1 = double(
      "line item 1",
      id: "line-item-1-id",
      timesheet_id: "timesheet-id",
      description: "description 1",
      hourly_rate: 24,
      total_decimal_hours: "total decimal hours 1",
      subtotal: "subtotal 1",
      weekday: "monday",
    )
    @line_item_2 = double(
      "line item 2",
      id: "line-item-2-id",
      timesheet_id: "timesheet-id",
      description: "description 2",
      hourly_rate: 24,
      total_decimal_hours: "total decimal hours 2",
      subtotal: "subtotal 2",
      weekday: "monday",
    )
    @line_item_3 = double(
      "line item 3",
      id: "line-item-3-id",
      timesheet_id: "timesheet-id",
      description: "description 3",
      hourly_rate: 30,
      total_decimal_hours: "total decimal hours 3",
      subtotal: "subtotal 3",
      weekday: "wednesday",
    )

    timesheet = double(
      "timesheet",
      daily_line_items: {
        "monday" => [@line_item_1, @line_item_2],
        "wednesday" => [@line_item_3],
      },
    )
    line_item_summary_component = double("line item summary component")
    allow(LineItems::LineItemSummaryComponent).to receive(:new).and_return(line_item_summary_component)
    @component = Timesheets::DailyBreakdownComponent.new(timesheet:)
    allow(@component).to receive(:render).with(line_item_summary_component) { "rendered line item summary component" }
  end

  it "Displays a weekday-summary that contains a list group for each weekday" do
    render_inline(@component)

    daily_breakdown = page.find("#daily-breakdown")

    expect(daily_breakdown).to have_css("h3", text: "Weekdays summary")
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
    expect(@component).to receive(:render).with(item_1_component) { "line item 1 rendered" }
    expect(@component).to receive(:render).with(item_2_component) { "line item 2 rendered" }
    expect(@component).to receive(:render).with(item_3_component) { "line item 3 rendered" }

    render_inline(@component)

    monday_summary = page.find_all(".weekday-summary")[0]

    expect(monday_summary).to have_content("line item 1 rendered")
    expect(monday_summary).to have_content("line item 2 rendered")

    wednesday_summary = page.find_all(".weekday-summary")[1]
    expect(wednesday_summary).to have_content("line item 3 rendered")
  end
end
