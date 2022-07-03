# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timesheets::TimesheetLineItemsSummaryComponent, type: :component do
  before do
    @timesheet = double(
      "A timesheet",
      grouped_line_items: [
        {
          description: "line item 1 description",
          total_decimal_hours: 12.6666666,
          hourly_rate: 30,
          subtotal: 379.9998,
        },
        {
          description: "line item 2 description",
          total_decimal_hours: 10,
          hourly_rate: 27,
          subtotal: 270,
        },
      ],
    )
    @component = Timesheets::TimesheetLineItemsSummaryComponent.new(timesheet: @timesheet)
  end

  it "renders a section for items summary" do
    render_inline(@component)
    expect(page).to have_css("section#items-summary")
    expect(page).to have_css("section#items-summary h3", text: "Items summary")
  end

  it "renders a summary for each item of the timesheet" do
    render_inline(@component)

    items_summary_section = page.find("section#items-summary")
    item_summary = items_summary_section.find_all("li.list-group-item.item-summary")
    expect(item_summary[0].find("h4.description").text).to eq("line item 1 description")
    expect(item_summary[0].find(".total-decimal-hours").text).to eq("12.67 hours")
    expect(item_summary[0].find(".hourly-rate").text).to eq("$30 per hour")
    expect(item_summary[0].find(".subtotal").text).to eq("$380.00")

    expect(item_summary[1].find("h4.description").text).to eq("line item 2 description")
    expect(item_summary[1].find(".total-decimal-hours").text).to eq("10.00 hours")
    expect(item_summary[1].find(".hourly-rate").text).to eq("$27 per hour")
    expect(item_summary[1].find(".subtotal").text).to eq("$270.00")
  end
end
